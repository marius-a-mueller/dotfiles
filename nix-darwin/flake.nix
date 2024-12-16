# install
# nix run nix-darwin -- switch --flake ~/.config/nix-darwin
# use
# darwin-rebuild switch --flake ~/.config/nix-darwin
{
  description = "Zenful Darwin Nix Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager, ... }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.bash
          pkgs.fish
          pkgs.neofetch
          pkgs.neovim
          pkgs.starship
          pkgs.gnupg
          pkgs.ansible
          pkgs.bartib
          pkgs.eza
          pkgs.ffmpeg
          pkgs.fd
          pkgs.git
          pkgs.krew
          pkgs.jq
          pkgs.kubernetes-helm
          pkgs.kubectl
          pkgs.pandoc
          pkgs.python314
          pkgs.gnused
          pkgs.k9s
          pkgs.go
          pkgs.lua
          pkgs.ncdu
          pkgs.ripgrep
          pkgs.zoxide
          pkgs.wget
          pkgs.yazi
          pkgs.yt-dlp
          pkgs.obsidian
          pkgs.aerospace
          pkgs.cyberduck
          pkgs.fzf
          pkgs.zotero
          pkgs.spotify
          pkgs.signal-desktop
          pkgs.rsync
          pkgs.fnm
        ];

      homebrew = {
        enable = true;
        brews = [
          "mas"
        ];
        casks = [
            "firefox"
            "wezterm"
            "raspberry-pi-imager"
            "android-file-transfer"
            "appcleaner"
            "applepi-baker"
            "coconutbattery"
            "coteditor"
            "daisydisk"
            "displaylink"
            "eqmac"
            "godot"
            "lulu"
            "malwarebytes"
            "jdownloader"
            "middleclick"
            "nextcloud"
            "numi"
            "prusaslicer"
            "prismlauncher"
            "deluge"
            "qr-journal"
            "slack"
            "tor-browser"
            "whatsapp"
            "bitwarden"
            "mullvad-browser"
            "iina"
            "the-unarchiver"
            "linearmouse"
            "anki"
            "spotify"
            "maccy"
        ];
        masApps = {
          "Yomu" = 562211012;
          "Amphetamine" = 937984704;
          "Wireguard" = 1451685025;
          "Shareful" = 1522267256;
        };
        onActivation.cleanup = "zap";
      };

      fonts.packages = with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.iosevka
      ];

      programs.fish.enable = true;
      ids.gids.nixbld = 350;

      system.activationScripts.postUserActivation.text = ''
        apps_source="${config.system.build.applications}/Applications"
        moniker="Nix Trampolines"
        app_target_base="/Applications"
        app_target="$app_target_base/$moniker"
        mkdir -p "$app_target"
        sudo ${pkgs.rsync}/bin/rsync --archive --checksum --chmod=-w --copy-unsafe-links --delete "$apps_source/" "$app_target"
      '';

      security.pam.enableSudoTouchIdAuth = true;

      system.defaults = {
        dock.autohide  = true;
        dock.persistent-apps = [
          "${pkgs.wezterm}/Applications/WezTerm.app"
          "/Applications/Firefox.app"
          "/Applications/Mullvad Browser.app"
          "${pkgs.obsidian}/Applications/Obsidian.app"
          "/System/Applications/Mail.app"
          "/System/Applications/Calendar.app"
          "${pkgs.spotify}/Applications/Spotify.app"
          "/Applications/Bitwarden.app"
          "${pkgs.zotero}/Applications/Zotero.app"
        ];
        dock.persistent-others = [
          "/Users/marius/Downloads"
        ];
        dock.show-recents = false;
        loginwindow.GuestEnabled  = false;
        loginwindow.LoginwindowText = "emergency@archimarius.com";
        screencapture.location = "~/Downloads";
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        NSGlobalDomain.KeyRepeat = 2;
        WindowManager.EnableStandardClickToShowDesktop = false;
        finder.NewWindowTarget = "Home";
        finder.FXPreferredViewStyle = "Nlsv";
        finder.AppleShowAllExtensions = true;
        controlcenter.AirDrop = false;
        controlcenter.BatteryShowPercentage = false;
        controlcenter.NowPlaying = false;
        controlcenter.FocusModes = false;
        controlcenter.Display = false;
        controlcenter.Bluetooth = false;
        controlcenter.Sound = false;
      };

      system.keyboard.enableKeyMapping = true;
      system.keyboard.remapCapsLockToEscape = true;

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      programs.bash = {
        interactiveShellInit = ''
          if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
          then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
          fi
        '';
      };

      users.users.marius.home = "/Users/marius";
      home-manager.backupFileExtension = "backup";
      nix.configureBuildUsers = true;
      nix.useDaemon = true;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."MacBook" = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs; };
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            # Apple Silicon Only
            enableRosetta = true;
            # User owning the Homebrew prefix
            user = "marius";

            autoMigrate = true;
          };
        }
        home-manager.darwinModules.home-manager {
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.marius = import ./home.nix;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."MacBook".pkgs;
  };
}
