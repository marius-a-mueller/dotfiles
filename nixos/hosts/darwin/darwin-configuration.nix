{ pkgs, vars, config, ... }:
{
  imports = [
    ./modules
  ];

  users.users.${vars.user} = {
    home = "/Users/${vars.user}";
    shell = pkgs.wezterm;
  };

  environment = {
    variables = {
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };
    systemPackages = with pkgs; [
      mas # Mac App Store $ mas search <app>
      eza
      git
      neovim
      fish
      bat
      yazi
      aerospace
      direnv
      ncdu
      ripgrep
      wget
      fzf
      fastfetch
      starship
      fd
    ];
  };

  homebrew = {
    enable = true;
    onActivation = {
      upgrade = true;
      cleanup = "zap";
    };
    casks = [
      "appcleaner"
      "firefox"
      "wezterm"
    ];
    masApps = {
    };
  };

  home-manager.users.${vars.user} = { config, ...}: {
    home.stateVersion = "22.05";
    home.file = {
      ".config/fish".source = config.lib.file.mkOutOfStoreSymlink "/Users/${vars.user}/dotfiles/fish";
      ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink "/Users/${vars.user}/dotfiles/wezterm";
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/Users/${vars.user}/dotfiles/nvim";
      ".config/aerospace".source = config.lib.file.mkOutOfStoreSymlink "/Users/${vars.user}/dotfiles/aerospace";
      ".config/neofetch".source = config.lib.file.mkOutOfStoreSymlink "/Users/${vars.user}/dotfiles/neofetch";
      ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "/Users/${vars.user}/dotfiles/starship.toml";
      ".config/qBittorrent".source = config.lib.file.mkOutOfStoreSymlink "/Users/${vars.user}/dotfiles/qBittorrent";
      ".config/nixos".source = config.lib.file.mkOutOfStoreSymlink "/Users/${vars.user}/dotfiles/nix";
      ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink "/Users/${vars.user}/dotfiles/yazi";
      ".config/eza".source = config.lib.file.mkOutOfStoreSymlink "/Users/${vars.user}/dotfiles/eza";
    };
    home.sessionPath = [
      "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
    ];
    programs.home-manager.enable = true;
  };

  programs.fish.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.iosevka
  ];

  # link nix apps so they can be found in spotlight
  ids.gids.nixbld = 350;
  system.activationScripts.postUserActivation.text = ''
    apps_source="${config.system.build.applications}/Applications"
    moniker="Nix Trampolines"
    app_target_base="/Applications"
    app_target="$app_target_base/$moniker"
    mkdir -p "$app_target"
    sudo ${pkgs.rsync}/bin/rsync --archive --checksum --chmod=-w --copy-unsafe-links --delete "$apps_source/" "$app_target"
  '';

  nix = {
    package = pkgs.nix;
    gc = {
      automatic = true;
      interval.Day = 1;
      options = "--delete-older-than 1d";
    };
    extraOptions = ''
      # auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  security.pam.enableSudoTouchIdAuth = true;

  system.defaults = {
    dock.autohide  = true;
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

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  home-manager.backupFileExtension = "backup";
  nix.configureBuildUsers = true;
  nix.useDaemon = true;
}
