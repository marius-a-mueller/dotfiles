{ pkgs, lib, vars, config, inputs, ... }:
{
  config = {
    firefox.enable = true;

    environment.systemPackages = with pkgs; [
      direnv
      fish
      gnupg
      docker
      # lightweight vm for docker runtime
      colima
      ansible
      bartib
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
      yt-dlp
      ffmpeg
      obsidian
      cyberduck
      zotero
      spotify
      signal-desktop
      rsync
      fnm
      nixd
      alejandra
    ];

    nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

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
        "android-file-transfer"
        "angry-ip-scanner"
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
        "tailscale"
      ];
      masApps = {
        "Yomu" = 562211012;
        "Amphetamine" = 937984704;
        "Wireguard" = 1451685025;
        "Shareful" = 1522267256;
      };
    };
    system.defaults = {
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
    };
  };
}
