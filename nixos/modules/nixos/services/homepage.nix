{ lib, config, ... }:
let domain = "homepage.mindful-student.net";
in {
  options = {
    homepage.enable = lib.mkEnableOption "enables homepage";
  };
  config = lib.mkIf config.homepage.enable {
    services.nginx = {
      virtualHosts.${domain} = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.homepage-dashboard.listenPort}";
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
    services.homepage-dashboard = {
      enable = true;
      settings = {
        base = "https://${domain}";
      };
      services = [
        {
          "Hosts" = [
            {
              "Proxmox" = {
                href = "https://proxmox.mindful-student.net";
                icon = "proxmox";
                description = "VM Manager";
              };
            }
            {
              "OPNsense" = {
                href = "https://opnsense.mindful-student.net";
                icon = "opnsense";
                description = "Firewall";
              };
            }
          ];
        }
        {
          "Ourflix" = [
            {
              "Jellyfin" = {
                href = "https://jellyfin.mindful-student.net";
                icon = "jellyfin";
                description = "Streaming";
              };
            }
            {
              "Deluge" = {
                href = "https://deluge.mindful-student.net";
                icon = "deluge";
                description = "Torrenting";
              };
            }
            {
              "Sonarr" = {
                href = "https://sonarr.mindful-student.net";
                icon = "sonarr";
                description = "Series Finder";
              };
            }
            {
              "Radarr" = {
                href = "https://radarr.mindful-student.net";
                icon = "radarr";
                description = "Movie Finder";
              };
            }
            {
              "Jackett" = {
                href = "https://jackett.mindful-student.net";
                icon = "jackett";
                description = "Index Finder";
              };
            }
            {
              "Gluetun" = {
                icon = "gluetun";
                description = "VPN";
              };
            }
          ];
        }
      ];
    };
  };
}
