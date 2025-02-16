{ lib, config, ... }:
let domain = "gringotts.mindful-student.net";
in {
  options = {
    vaultwarden.enable = lib.mkEnableOption "vaultwarden";
  };
  config = lib.mkIf config.vaultwarden.enable {
    services.vaultwarden = {
      enable = true;
      backupDir = "/var/backup/vaultwarden";
      environmentFile = "/var/lib/vaultwarden.env";
      config = {
        DOMAIN = "https://${domain}";
        SIGNUPS_ALLOWED = false;

        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        ROCKET_LOG = "critical";

        # https://github.com/dani-garcia/vaultwarden/wiki/SMTP-configuration
        SMTP_HOST = "mail.your-server.de";
        SMTP_PORT = 587;
        SMTP_SECURITY = "starttls";
        SMTP_FROM_NAME = "Vaultwarden";
      };
    };
    services.nginx.virtualHosts."${domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
      };
    };
    security.acme.certs."${domain}" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialFiles = {
        "CF_DNS_API_TOKEN_FILE" = "/run/secrets/mindful-student.net";
      };
    };
  };
}
