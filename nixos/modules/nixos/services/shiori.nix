{ lib, config, ... }:
let domain = "bookmarks.mindful-student.net";
in {
  options = {
    shiori.enable = lib.mkEnableOption "enables shiori";
  };
  config = lib.mkIf config.shiori.enable {
    services.shiori = {
      enable = true;
      port = 8080;
      address = "127.0.0.1";
    };
    services.nginx = {
      virtualHosts.${domain} = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://${config.services.shiori.address}:${toString config.services.shiori.port}";
          recommendedProxySettings = true;
        };
      };
    };
    security.acme.certs."${domain}" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialFiles = {
        "CF_DNS_API_TOKEN_FILE" = "/var/lib/mindful-student.net";
      };
    };
  };
}
