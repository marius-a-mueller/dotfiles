{ pkgs, lib, config, vars, ... }:
let domain = "wallabag.mindful-student.net";
in {
  options = {
    wallabag.enable = lib.mkEnableOption "wallabag";
  };
  config = lib.mkIf config.wallabag.enable {
    services.nginx = {
      virtualHosts.${domain} = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8880";
          proxyWebsockets = true;
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

    # Runtime
    virtualisation.podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        # Required for container networking to be able to use names.
        dns_enabled = true;
      };
    };
   
    # Enable container name DNS for non-default Podman networks.
    # https://github.com/NixOS/nixpkgs/issues/226365
    networking.firewall.interfaces."podman+".allowedUDPPorts = [ 53 ];
   
    virtualisation.oci-containers.backend = "podman";
   
    # Containers
    virtualisation.oci-containers.containers."wallabag-redis" = {
      image = "redis:alpine";
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=[\"redis-cli\", \"ping\"]"
        "--health-interval=20s"
        "--health-timeout=3s"
        "--network-alias=redis"
        "--network=wallabag_default"
      ];
    };
    systemd.services."podman-wallabag-redis" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      after = [
        "podman-network-wallabag_default.service"
      ];
      requires = [
        "podman-network-wallabag_default.service"
      ];
      partOf = [
        "podman-compose-wallabag-root.target"
      ];
      wantedBy = [
        "podman-compose-wallabag-root.target"
      ];
    };
    virtualisation.oci-containers.containers."wallabag-wallabag" = {
      image = "wallabag/wallabag";
      environment = {
        "SYMFONY__ENV__DATABASE_DRIVER" = "pdo_sqlite";
        "SYMFONY__ENV__DOMAIN_NAME" = "https://${domain}";
        "SYMFONY__ENV__SERVER_NAME" = "Mindful Wallabag";
      };
      volumes = [
        "wallabag_wallabag_data:/var/www/wallabag/data:rw"
        "wallabag_wallabag_images:/var/www/wallabag/web/assets/images:rw"
      ];
      ports = [
        "8880:80/tcp"
      ];
      dependsOn = [
        "wallabag-redis"
      ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=[\"wget\", \"--no-verbose\", \"--tries=1\", \"--spider\", \"http://localhost/api/info\"]"
        "--health-interval=1m0s"
        "--health-timeout=3s"
        "--network-alias=wallabag"
        "--network=wallabag_default"
      ];
    };
    systemd.services."podman-wallabag-wallabag" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      after = [
        "podman-network-wallabag_default.service"
        "podman-volume-wallabag_wallabag_data.service"
        "podman-volume-wallabag_wallabag_images.service"
      ];
      requires = [
        "podman-network-wallabag_default.service"
        "podman-volume-wallabag_wallabag_data.service"
        "podman-volume-wallabag_wallabag_images.service"
      ];
      partOf = [
        "podman-compose-wallabag-root.target"
      ];
      wantedBy = [
        "podman-compose-wallabag-root.target"
      ];
    };
   
    # Networks
    systemd.services."podman-network-wallabag_default" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "podman network rm -f wallabag_default";
      };
      script = ''
        podman network inspect wallabag_default || podman network create wallabag_default
      '';
      partOf = [ "podman-compose-wallabag-root.target" ];
      wantedBy = [ "podman-compose-wallabag-root.target" ];
    };
   
    # Volumes
    systemd.services."podman-volume-wallabag_wallabag_data" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        podman volume inspect wallabag_wallabag_data || podman volume create wallabag_wallabag_data
      '';
      partOf = [ "podman-compose-wallabag-root.target" ];
      wantedBy = [ "podman-compose-wallabag-root.target" ];
    };
    systemd.services."podman-volume-wallabag_wallabag_images" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        podman volume inspect wallabag_wallabag_images || podman volume create wallabag_wallabag_images
      '';
      partOf = [ "podman-compose-wallabag-root.target" ];
      wantedBy = [ "podman-compose-wallabag-root.target" ];
    };
   
    # Root service
    # When started, this will automatically create all resources and start
    # the containers. When stopped, this will teardown all resources.
    systemd.targets."podman-compose-wallabag-root" = {
      unitConfig = {
        Description = "Root target generated by compose2nix.";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
