{ pkgs, lib, config, vars, ... }:
let domain = "overleaf.mindful-student.net";
in {
  options = {
    overleaf.enable = lib.mkEnableOption "overleaf";
  };
  config = lib.mkIf config.overleaf.enable {
    services.nginx = {
      virtualHosts.${domain} = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8767";
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

    systemd.tmpfiles.rules = [
      "d /opt/overleaf/server-ce/ 0770 ${vars.user} users -"
      "f /opt/overleaf/server-ce/mongodb-init-replica-set.js 0770 ${vars.user} users -"
    ];

    environment.etc = {
      "mongo_setup.sh" = {
        text = ''
          #!/bin/bash
          echo "sleeping for 10 seconds"
          sleep 10
          echo mongo_setup.sh time now: `date +"%T" `
          mongosh --host mongo:27017 <<EOF
            var cfg = {
              "_id": "overleaf",
              "version": 1,
              "members": [
                {
                  "_id": 0,
                  "host": "mongo:27017",
                  "priority": 2
                }
              ]
            };
            rs.initiate(cfg);
          EOF
        '';
        mode = "0666";
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

    virtualisation.containers.storage.settings = {
      storage = {
        graphroot = "/var/lib/containers/storage";
        runroot = "/run/containers/storage";
      };
    };

    # Enable container name DNS for non-default Podman networks.
    # https://github.com/NixOS/nixpkgs/issues/226365
    networking.firewall.interfaces."podman+".allowedUDPPorts = [ 53 ];

    virtualisation.oci-containers.backend = "podman";

    # Containers
    virtualisation.oci-containers.containers."mongo" = {
      image = "docker.io/mongo:6.0";
      environment = {
        "MONGO_INITDB_DATABASE" = "sharelatex";
      };
      volumes = [
        "/opt/overleaf/server-ce/mongodb-init-replica-set.js:/docker-entrypoint-initdb.d/mongodb-init-replica-set.js:rw"
        "mongo_data:/data/db:rw"
      ];
      cmd = [ "--bind_ip_all" "--replSet" "overleaf" ];
      log-driver = "journald";
      extraOptions = [
        # "--add-host=mongo:127.0.0.1"
        "--health-cmd=echo 'db.stats().ok' | mongo localhost:27017/test --quiet"
        "--health-interval=10s"
        "--health-retries=5"
        "--health-timeout=10s"
        "--network-alias=mongo"
        "--hostname=mongo"
        "--network=overleaf_default"
      ];
    };
    systemd.services."podman-mongo" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      after = [
        "podman-network-overleaf_default.service"
      ];
      requires = [
        "podman-network-overleaf_default.service"
      ];
      partOf = [
        "podman-compose-overleaf-root.target"
      ];
      wantedBy = [
        "podman-compose-overleaf-root.target"
      ];
    };
    virtualisation.oci-containers.containers."mongo-mongosetup" = {
      image = "docker.io/mongo:6.0";
      volumes = [
        "/etc/mongo_setup.sh:/scripts/mongo_setup.sh:rw"
      ];
      dependsOn = [
        "mongo"
      ];
      log-driver = "journald";
      extraOptions = [
        "--entrypoint=[\"bash\", \"/scripts/mongo_setup.sh\"]"
        "--network-alias=mongosetup"
        "--network=overleaf_default"
      ];
    };
    systemd.services."podman-mongo-mongosetup" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "no";
        RemainAfterExit = lib.mkOverride 90 "yes";
      };
      after = [
        "podman-network-overleaf_default.service"
      ];
      requires = [
        "podman-network-overleaf_default.service"
      ];
      partOf = [
        "podman-compose-overleaf-root.target"
      ];
      wantedBy = [
        "podman-compose-overleaf-root.target"
      ];
    };
    virtualisation.oci-containers.containers."redis" = {
      image = "docker.io/redis:6.2";
      volumes = [
        "redis_data:/data:Z"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=redis"
        "--network=overleaf_default"
      ];
    };
    systemd.services."podman-redis" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      after = [
        "podman-network-overleaf_default.service"
      ];
      requires = [
        "podman-network-overleaf_default.service"
      ];
      partOf = [
        "podman-compose-overleaf-root.target"
      ];
      wantedBy = [
        "podman-compose-overleaf-root.target"
      ];
    };
    virtualisation.oci-containers.containers."sharelatex" = {
      image = "docker.io/rigon/sharelatex-full";
      environment = {
        "OVERLEAF_SITE_URL" = "https://${domain}";
        "OVERLEAF_BEHIND_PROXY" = "true";
        "OVERLEAF_SECURE_COOKIE" = "true";
        "EMAIL_CONFIRMATION_DISABLED" = "true";
        "ENABLED_LINKED_FILE_TYPES" = "project_file,project_output_file";
        "ENABLE_CONVERSIONS" = "true";
        "OVERLEAF_APP_NAME" = "Overleaf Community Edition";
        "OVERLEAF_MONGO_URL" = "mongodb://mongo/sharelatex";
        "OVERLEAF_REDIS_HOST" = "redis";
        "REDIS_HOST" = "redis";
        "SANDBOXED_COMPILES" = "true";
        "SANDBOXED_COMPILES_HOST_DIR" = "/home/user/sharelatex_data/data/compiles";
        "SANDBOXED_COMPILES_SIBLING_CONTAINERS" = "true";
      };
      volumes = [
        "sharelatex_data:/var/lib/overleaf"
        # "/opt/overleaf/nginx_data:/etc/nginx/sites-enabled:rw"
      ];
      ports = [
        "8767:80/tcp"
      ];
      dependsOn = [
        "mongo"
        "redis"
      ];
      log-driver = "journald";
      extraOptions = [
        "--sysctl=net.ipv6.conf.all.disable_ipv6=1"
        "--network-alias=sharelatex"
        "--network=overleaf_default"
      ];
    };
    systemd.services."podman-sharelatex" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      after = [
        "podman-network-overleaf_default.service"
      ];
      requires = [
        "podman-network-overleaf_default.service"
      ];
      partOf = [
        "podman-compose-overleaf-root.target"
      ];
      wantedBy = [
        "podman-compose-overleaf-root.target"
      ];
    };

    # Networks
    systemd.services."podman-network-overleaf_default" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "podman network rm -f overleaf_default";
      };
      script = ''
        podman network inspect overleaf_default || podman network create overleaf_default
      '';
      partOf = [ "podman-compose-overleaf-root.target" ];
      wantedBy = [ "podman-compose-overleaf-root.target" ];
    };

    # Root service
    # When started, this will automatically create all resources and start
    # the containers. When stopped, this will teardown all resources.
    systemd.targets."podman-compose-overleaf-root" = {
      unitConfig = {
        Description = "Root target generated by compose2nix.";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
