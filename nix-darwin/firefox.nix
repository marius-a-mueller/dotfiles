{ config, pkgs, inputs, ... }:

{
  programs = {
    firefox = {
      enable = true;
      package = null;
      profiles.marius = {
        isDefault = true;
        search.engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
        };
        search.force = true;

        bookmarks = [
          {
            name = "wikipedia";
            tags = [ "wiki" ];
            keyword = "wiki";
            url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
          }
        ];

        settings = {
          "dom.security.https_only_mode" = true;
          "browser.download.panel.shown" = true;
          "identity.fxaccounts.enabled" = false;
          "signon.rememberSignons" = false;
        };

        userChrome = ''
          /* some css */
        '';

        # nix flake show "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"
        extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
          ublock-origin
          sponsorblock
          youtube-shorts-block
          return-youtube-dislikes
          bitwarden
          vimium
          libredirect
          i-dont-care-about-cookies
          startpage-private-search
          zotero-connector
        ];

      };
      policies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          EnableTrackingProtection = {
              Value= true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
          };
          DisablePocket = true;
          DisableFirefoxAccounts = true;
          DisableAccounts = true;
          DisableFirefoxScreenshots = true;
          OverrideFirstRunPage = "";
          OverridePostUpdatePage = "";
          DontCheckDefaultBrowser = true;
          DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
          DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
          SearchBar = "unified"; # alternative: "separate"
      };

      /* ---- POLICIES ---- */
      # Check about:policies#documentation for options.
      # policies = {
      #   DisableTelemetry = true;
      #   DisableFirefoxStudies = true;
      #   EnableTrackingProtection = {
      #     Value= true;
      #     Locked = true;
      #     Cryptomining = true;
      #     Fingerprinting = true;
      #   };
      #   DisablePocket = true;
      #   DisableFirefoxAccounts = true;
      #   DisableAccounts = true;
      #   DisableFirefoxScreenshots = true;
      #   OverrideFirstRunPage = "";
      #   OverridePostUpdatePage = "";
      #   DontCheckDefaultBrowser = true;
      #   DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
      #   DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      #   SearchBar = "unified"; # alternative: "separate"

      #   /* ---- EXTENSIONS ---- */
      #   # Check about:support for extension/add-on ID strings.
      #   # Valid strings for installation_mode are "allowed", "blocked",
      #   # "force_installed" and "normal_installed".
      #   ExtensionSettings = {
      #     "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
      #     # uBlock Origin:
      #     "uBlock0@raymondhill.net" = {
      #       install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      #       installation_mode = "force_installed";
      #     };
      #     # Privacy Badger:
      #     "jid1-MnnxcxisBPnSXQ@jetpack" = {
      #       install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
      #       installation_mode = "force_installed";
      #     };
      #   };

      #   /* ---- PREFERENCES ---- */
      #   # Check about:config for options.
      #   Preferences = {
      #     "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
      #     "extensions.pocket.enabled" = lock-false;
      #     "extensions.screenshots.disabled" = lock-true;
      #     "browser.topsites.contile.enabled" = lock-false;
      #     "browser.formfill.enable" = lock-false;
      #     "browser.search.suggest.enabled" = lock-false;
      #     "browser.search.suggest.enabled.private" = lock-false;
      #     "browser.urlbar.suggest.searches" = lock-false;
      #     "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
      #     "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
      #     "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
      #     "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
      #     "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
      #     "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
      #     "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
      #     "browser.newtabpage.activity-stream.showSponsored" = lock-false;
      #     "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
      #     "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
      #   };
      # };
    };
  };
}
