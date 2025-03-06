{ pkgs, lib, config, ... }:
let
  domain = "pangolin.mindful-student.net";
  traefik_config = ''
api:
  insecure: false
  dashboard: false

providers:
  http:
    endpoint: "http://pangolin:3001/api/v1/traefik-config"
    pollInterval: "5s"
  file:
    filename: "/etc/traefik/dynamic_config.yml"

experimental:
  plugins:
    badger:
      moduleName: "github.com/fosrl/badger"
      version: "v1.0.0"

log:
  level: "INFO"
  format: "common"

certificatesResolvers:
  letsencrypt:
    acme:
      httpChallenge:
        entryPoint: web
      email: acme@mindful-student.net # REPLACE THIS WITH YOUR EMAIL
      storage: "/letsencrypt/acme.json"
      caServer: "https://acme-v02.api.letsencrypt.org/directory"

entryPoints:
  web:
    address: ":80"
  websecure:
    address: ":443"
    transport:
      respondingTimeouts:
        readTimeout: "30m"
    http:
      tls:
        certResolver: "letsencrypt"

serversTransport:
  insecureSkipVerify: true
  '';
  dynamic_config = ''
http:
  middlewares:
    redirect-to-https:
      redirectScheme:
        scheme: https

  routers:
    # HTTP to HTTPS redirect router
    main-app-router-redirect:
      rule: "Host(\`${domain}\`)" # REPLACE THIS WITH YOUR DOMAIN
      service: next-service
      entryPoints:
        - web
      middlewares:
        - redirect-to-https

    # Next.js router (handles everything except API and WebSocket paths)
    next-router:
      rule: "Host(\`${domain}\`) && !PathPrefix(\`/api/v1\`)" # REPLACE THIS WITH YOUR DOMAIN
      service: next-service
      entryPoints:
        - websecure
      tls:
        certResolver: letsencrypt

    # API router (handles /api/v1 paths)
    api-router:
      rule: "Host(\`${domain}\`) && PathPrefix(\`/api/v1\`)" # REPLACE THIS WITH YOUR DOMAIN
      service: api-service
      entryPoints:
        - websecure
      tls:
        certResolver: letsencrypt

    # WebSocket router
    ws-router:
      rule: "Host(\`${domain}\`)" # REPLACE THIS WITH YOUR DOMAIN
      service: api-service
      entryPoints:
        - websecure
      tls:
        certResolver: letsencrypt

  services:
    next-service:
      loadBalancer:
        servers:
          - url: "http://pangolin:3002" # Next.js server

    api-service:
      loadBalancer:
        servers:
          - url: "http://pangolin:3000" # API/WebSocket server
  '';
  pangolin_config = ''
app:
    dashboard_url: "https://${domain}"
    log_level: "info"
    save_logs: false

domains:
    domain1:
        base_domain: "${domain}"
        cert_resolver: "letsencrypt"
        prefer_wildcard_cert: false

server:
    external_port: 3000
    internal_port: 3001
    next_port: 3002
    internal_hostname: "pangolin"
    session_cookie_name: "p_session_token"
    resource_access_token_param: "p_token"
    resource_session_request_param: "p_session_request"

traefik:
    cert_resolver: "letsencrypt"
    http_entrypoint: "web"
    https_entrypoint: "websecure"

gerbil:
    start_port: 51820
    base_endpoint: "${domain}"
    use_subdomain: false
    block_size: 24
    site_block_size: 30
    subnet_group: 100.89.137.0/20

rate_limits:
    global:
        window_minutes: 1
        max_requests: 100

users:
    server_admin:
        email: "mm@mindful-student.net"
        password: "su2rIrlQw8cBq#38VRuBqizT8X!hf%Xv"

flags:
    require_email_verification: true
    disable_signup_without_invite: true
    disable_user_create_org: true
    allow_raw_resources: true
    allow_base_domain_resources: true
  '';
in {
  options = {
    pangolin-server.enable = lib.mkEnableOption "pangolin-server";
  };
  config = lib.mkIf config.pangolin-server.enable {

    system.activationScripts = {
      pangolin = {
        text =
          ''
            mkdir -m 0750 -p /opt/pangolin/config/{db,letsencrypt,traefik,logs}
            cat << eof > /opt/pangolin/config/traefik/traefik_config.yml
            ${traefik_config}
            eof
            cat << eof > /opt/pangolin/config/traefik/dynamic_config.yml
            ${dynamic_config}
            eof
            cat << eof > /opt/pangolin/config/config.yml
            ${pangolin_config}
            eof
          '';
      };
    }
    ;

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
    virtualisation.oci-containers.containers."gerbil" = {
      image = "fosrl/gerbil:1.0.0";
      volumes = [
        "/opt/pangolin/config:/var/config:rw"
      ];
      ports = [
        "51820:51820/udp"
        "443:443/tcp"
        "80:80/tcp"
      ];
      cmd = [ "--reachableAt=http://gerbil:3003" "--generateAndSaveKeyTo=/var/config/key" "--remoteConfig=http://pangolin:3001/api/v1/gerbil/get-config" "--reportBandwidthTo=http://pangolin:3001/api/v1/gerbil/receive-bandwidth" ];
      dependsOn = [
        "pangolin"
      ];
      log-driver = "journald";
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--cap-add=SYS_MODULE"
        "--network-alias=gerbil"
        "--network=pangolin"
      ];
    };
    systemd.services."podman-gerbil" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      after = [
        "podman-network-pangolin.service"
      ];
      requires = [
        "podman-network-pangolin.service"
      ];
      partOf = [
        "podman-compose-pangolin-root.target"
      ];
      wantedBy = [
        "podman-compose-pangolin-root.target"
      ];
    };
    virtualisation.oci-containers.containers."pangolin" = {
      image = "fosrl/pangolin:1.0.0";
      volumes = [
        "/opt/pangolin/config:/app/config:rw"
      ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=[\"curl\", \"-f\", \"http://localhost:3001/api/v1/\"]"
        "--health-interval=3s"
        "--health-retries=5"
        "--health-timeout=3s"
        "--network-alias=pangolin"
        "--network=pangolin"
      ];
    };
    systemd.services."podman-pangolin" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      after = [
        "podman-network-pangolin.service"
      ];
      requires = [
        "podman-network-pangolin.service"
      ];
      partOf = [
        "podman-compose-pangolin-root.target"
      ];
      wantedBy = [
        "podman-compose-pangolin-root.target"
      ];
    };
    virtualisation.oci-containers.containers."traefik" = {
      image = "traefik:v3.3.3";
      volumes = [
        "/opt/pangolin/config/letsencrypt:/letsencrypt:rw"
        "/opt/pangolin/config/traefik:/etc/traefik:ro"
      ];
      cmd = [ "--configFile=/etc/traefik/traefik_config.yml" ];
      dependsOn = [
        "gerbil"
        "pangolin"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network=container:gerbil"
      ];
    };
    systemd.services."podman-traefik" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      partOf = [
        "podman-compose-pangolin-root.target"
      ];
      wantedBy = [
        "podman-compose-pangolin-root.target"
      ];
    };

    # Networks
    systemd.services."podman-network-pangolin" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "podman network rm -f pangolin";
      };
      script = ''
        podman network inspect pangolin || podman network create pangolin --driver=bridge
      '';
      partOf = [ "podman-compose-pangolin-root.target" ];
      wantedBy = [ "podman-compose-pangolin-root.target" ];
    };

    # Root service
    # When started, this will automatically create all resources and start
    # the containers. When stopped, this will teardown all resources.
    systemd.targets."podman-compose-pangolin-root" = {
      unitConfig = {
        Description = "Root target generated by compose2nix.";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}

