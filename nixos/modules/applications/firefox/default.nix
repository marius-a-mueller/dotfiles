{ config, pkgs, inputs, lib, vars, ... }:
{
  options = {
    firefox.enable = lib.mkEnableOption "enables firefox";
  };
  config = lib.mkIf config.firefox.enable {
    home-manager.users.${vars.user} = {
      home.sessionVariables = {
        MOZ_LEGACY_PROFILES = 1;
        MOZ_ALLOW_DOWNGRADE = 1;
      };
      programs = {
        firefox = {
          enable = true;
          package = null;
          profiles.${vars.user} = {
            isDefault = true;
            search.engines = {
              "Startpage" = {
                urls = [{
                  template = "https://www.startpage.com/sp/search";
                  params = [
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];

                icon = https://raw.githubusercontent.com/simple-icons/simple-icons/refs/heads/develop/icons/startpage.svg;
                definedAliases = [ "@s" ];
              };
              "Nix Packages" = {
                urls = [{
                  template = "https://search.nixos.org/packages?channel=unstable";
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
            search.default = "Startpage";

            bookmarks = [
              {
                name = "wikipedia";
                tags = [ "wiki" ];
                keyword = "wiki";
                url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
              }
            ];

            userChrome = builtins.readFile ./userChrome.css;

            # nix flake show "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"
            extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
              ublock-origin
              sponsorblock
              youtube-shorts-block
              return-youtube-dislikes
              bitwarden
              vimium
              libredirect
              old-reddit-redirect
              i-dont-care-about-cookies
              zotero-connector
              youtube-shorts-block
              export-tabs-urls-and-titles
              darkreader
              floccus
            ];
            settings = {
              "sidebar.revamp" = true;
              "sidebar.verticalTabs" = true;
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              "apz.allow_zooming" = true;
              "browser.aboutConfig.showWarning" = false;
              "browser.tabs.warnOnClose" = true;
              "browser.fullscreen.autohide" = false;
              "browser.newtabpage.pinned" = "";
              "browser.startup.homepage" = "https://startpage.com";
              "browser.tabs.loadInBackground" = false;
              "browser.urlbar.update2" = true;
              "browser.urlbar.shortcuts.bookmarks" = false;
              "browser.urlbar.shortcuts.tabs" = false;
              "browser.urlbar.shortcuts.history" = false;
              "dom.security.https_only_mode" = true;
              "browser.download.panel.shown" = true;
              "identity.fxaccounts.enabled" = false;
              "extensions.pocket.enabled" = false;
              "browser.formfill.enable" = false;
              "signon.rememberSignons" = false;
              "browser.search.hiddenOneOffs" =
                lib.strings.concatStringsSep "," [
                  "Google"
                  "Amazon.com"
                  "Amazon.de"
                  "Bing"
                  "Chambers (UK)"
                  "DuckDuckGo"
                  "eBay"
                  "Wikipedia (en)"
                ];
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
            };
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
              FirefoxHome = {
                  SponsoredTopSites = false;
                  SponsoredPocket = false;
              };
          };
        };
      };
    };
  };
}
