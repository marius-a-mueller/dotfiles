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
        server_url = "https://${domain}";
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
