{ lib, config, ... }:
let domain = "monitoring.mindful-student.net";
in {
  options = {
    grafana.enable = lib.mkEnableOption "enables grafana";
  };
  config = lib.mkIf config.grafana.enable {
    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 3000;
          enforce_domain = true;
          enable_gzip = true;
          domain = "${domain}";
        };
        # Prevents Grafana from phoning home
        analytics.reporting_enabled = false;
      };
      provision = {
        enable = true;
        datasources.settings.datasources = [
          # "Built-in" datasources can be provisioned - c.f. https://grafana.com/docs/grafana/latest/administration/provisioning/#data-sources
          {
            name = "Prometheus";
            type = "prometheus";
            url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
          }
        ];
      };
    };
    services.nginx = {
      virtualHosts.${domain} = {
        forceSSL = true;
        enableACME = true;
        extraConfig = ''
          client_max_body_size 512M;
        '';
        locations."/" = {
          proxyPass = "http://${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
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
  };
}
