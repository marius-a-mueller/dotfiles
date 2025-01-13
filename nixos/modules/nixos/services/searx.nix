{ lib, config, ... }:
let domain = "searx.mindful-student.net";
in {
  options = {
    searx.enable = lib.mkEnableOption "searx";
  };
  config = lib.mkIf config.searx.enable {
    services.searx = {
      enable = true;
      redisCreateLocally = true;

      # UWSGI configuration
      runInUwsgi = true;

      uwsgiConfig = {
        socket = "/run/searx/searx.sock";
        http = ":8888";
        chmod-socket = "660";
      };

      # Searx configuration
      # https://docs.searxng.org/admin/installation-searxng.html#configuration
      settings = {
        # Instance settings
        general = {
          debug = false;
          instance_name = "SearXNG Instance";
          donation_url = false;
          contact_url = false;
          privacypolicy_url = false;
          enable_metrics = false;
        };

        # User interface
        ui = {
          static_use_hash = true;
          default_locale = "en";
          query_in_title = true;
          results_on_new_tab = true;
          infinite_scroll = false;
          center_alignment = true;
          default_theme = "simple";
          theme_args.simple_style = "auto";
          search_on_category_select = true;
          hotkeys = "vim";
        };

        # Search engine settings
        search = {
          safe_search = 1;
          autocomplete_min = 2;
          autocomplete = "duckduckgo";
          ban_time_on_fail = 5;
          max_ban_time_on_fail = 120;
        };

        # Server configuration
        server = {
          base_url = "https://${domain}";
          port = 8888;
          bind_address = "127.0.0.1";
          secret_key = "";
          # limiter = true;
          public_instance = true;
          image_proxy = true;
          method = "GET";
        };

        # Search engines
        engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {
          "duckduckgo".disabled = true;
          "brave".disabled = true;
          "bing".disabled = false;
          "mojeek".disabled = true;
          "mwmbl".disabled = true;
          "mwmbl".weight = 0.4;
          "qwant".disabled = true;
          "crowdview".disabled = true;
          "curlie".disabled = true;
          "ddg definitions".disabled = false;
          "ddg definitions".weight = 2;
          "wikibooks".disabled = true;
          "wikidata".disabled = true;
          "wikiquote".disabled = true;
          "wikisource".disabled = true;
          "wikispecies".disabled = true;
          "wikiversity".disabled = true;
          "wikivoyage".disabled = true;
          "currency".disabled = true;
          "dictzone".disabled = true;
          "lingva".disabled = true;
          "bing images".disabled = false;
          "brave.images".disabled = true;
          "duckduckgo images".disabled = true;
          "google images".disabled = false;
          "qwant images".disabled = true;
          "1x".disabled = true;
          "artic".disabled = false;
          "deviantart".disabled = false;
          "flickr".disabled = true;
          "imgur".disabled = false;
          "library of congress".disabled = true;
          "material icons".disabled = true;
          "material icons".weight = 0.2;
          "openverse".disabled = false;
          "pinterest".disabled = true;
          "svgrepo".disabled = false;
          "unsplash".disabled = false;
          "wallhaven".disabled = false;
          "wikicommons.images".disabled = false;
          "yacy images".disabled = true;
          "bing videos".disabled = false;
          "brave.videos".disabled = true;
          "duckduckgo videos".disabled = true;
          "google videos".disabled = false;
          "qwant videos".disabled = false;
          "dailymotion".disabled = true;
          "google play movies".disabled = true;
          "invidious".disabled = true;
          "odysee".disabled = true;
          "peertube".disabled = false;
          "piped".disabled = true;
          "rumble".disabled = false;
          "sepiasearch".disabled = false;
          "vimeo".disabled = true;
          "youtube".disabled = false;
          "brave.news".disabled = true;
          "google news".disabled = true;
        };

        # Outgoing requests
        outgoing = {
          request_timeout = 5.0;
          max_request_timeout = 15.0;
          pool_connections = 100;
          pool_maxsize = 15;
          enable_http2 = true;
        };

        # Enabled plugins
        enabled_plugins = [
          "Basic Calculator"
          "Hash plugin"
          "Tor check plugin"
          "Open Access DOI rewrite"
          "Hostnames plugin"
          "Unit converter plugin"
          "Tracker URL remover"
        ];
      };
    };

    # Systemd configuration
    systemd.services.nginx.serviceConfig.ProtectHome = false;

    # User management
    users.groups.searx.members = ["nginx"];

    # Nginx configuration
    services.nginx = {
      virtualHosts = {
        "${domain}" = {
          extraConfig = ''
          ssl_protocols          TLSv1.2 TLSv1.3;
          ssl_ciphers            HIGH:!aNULL:!MD5;
          ssl_client_certificate /var/ca.crt;
          ssl_verify_client      optional;
          ssl_verify_depth       3;
          '';
          forceSSL = true;
          enableACME = true;
          locations = {
            # code 444 in nginx means drop connection
            "/" = {
              extraConfig = ''
            if ($ssl_client_verify != SUCCESS) {
              return 444;
            }
            uwsgi_pass unix:${config.services.searx.uwsgiConfig.socket};
              '';
            };
          };
        };
      };
    };
  };
}
