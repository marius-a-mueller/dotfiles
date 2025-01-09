{ lib, config, ... }:
let domain = "bin.mindful-student.net";
in {
  options = {
    privatebin.enable = lib.mkEnableOption "privatebin";
  };
  config = lib.mkIf config.privatebin.enable {

    services = {
      privatebin = {
        enable = true;
        # enableNginx = true;
        # virtualHost = "${domain}";
      };

      # nginx.enable = true;
      # nginx.virtualHosts.${domain} = {
      #   forceSSL = true;
      #   enableACME = true;
      #   locations."/" = {
      #     proxyPass =
      #       "http://localhost:${toString config.services.headscale.port}";
      #     proxyWebsockets = true;
      #   };
      # };
    };
  };
}
