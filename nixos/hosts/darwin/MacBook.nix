{ pkgs, lib, vars, config, ... }:
{
  firefox.enable = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    with pkgs; [
      bat
      fish
      docker
      # lightweight vm for docker runtime
      colima
      neovim
      fastfetch
      nixos-generators
      starship
      gnupg
      ansible
      bartib
      eza
      ffmpeg
      fd
      git
      krew
      jq
      kubernetes-helm
      kubectl
      pandoc
      python314
      gnused
      k9s
      go
      lua
      ncdu
      ripgrep
      zoxide
      wget
      yazi
      yt-dlp
      obsidian
      aerospace
      cyberduck
      fzf
      zotero
      spotify
      signal-desktop
      rsync
      fnm
      direnv
    ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    brews = [
    ];
    casks = [
        "firefox"
        "wezterm"
        "raspberry-pi-imager"
        "android-file-transfer"
        "appcleaner"
        "balenaetcher"
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
        "stats"
        "tunnelblick"
    ];
    masApps = {
      "Yomu" = 562211012;
      "Amphetamine" = 937984704;
      "Wireguard" = 1451685025;
      "Shareful" = 1522267256;
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.iosevka
  ];

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
      "/Users/${vars.user}/Downloads"
    ];
    CustomUserPreferences = {
      "com.apple.desktopservices" = {
        # Disable creating .DS_Store files in network an USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      # Privacy
      "com.apple.AdLib".allowApplePersonalizedAdvertising = false;
    };
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


  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  # nixpkgs.hostPlatform = "aarch64-darwin";

  home-manager.backupFileExtension = "backup";
  nix.configureBuildUsers = true;
  nix.useDaemon = true;
}
