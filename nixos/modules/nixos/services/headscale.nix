{ lib, config, ... }:
let domain = "headscale.mindful-student.net";
in {
  options = {
    headscale.enable = lib.mkEnableOption "enables headscale";
  };
  config = lib.mkIf config.headscale.enable {
    services = {
      headscale = {
        enable = true;
        address = "0.0.0.0";
        port = 8080;
        settings = {
          server_url = "https://${domain}:443";
          dns = {
            base_domain = "magic.local";
            nameservers.global = [ "100.64.0.3" ];
          };
        };
      };

      nginx.virtualHosts.${domain} = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass =
            "http://localhost:${toString config.services.headscale.port}";
          proxyWebsockets = true;
        };
      };
    };
    environment.systemPackages = [ config.services.headscale.package ];
  };
}
