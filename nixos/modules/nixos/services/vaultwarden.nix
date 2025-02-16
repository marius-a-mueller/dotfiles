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
        DOMAIN = "${domain}";
        SIGNUPS_ALLOWED = false;

        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        ROCKET_LOG = "critical";

        # https://github.com/dani-garcia/vaultwarden/wiki/SMTP-configuration
        # SMTP_HOST = "127.0.0.1";
        # SMTP_PORT = 25;
        # SMTP_SSL = false;

        # SMTP_FROM = "admin@bitwarden.example.com";
        # SMTP_FROM_NAME = "example.com Bitwarden server";
      };
    };
    services.nginx.virtualHosts."${domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
      };
    };
  };
}
