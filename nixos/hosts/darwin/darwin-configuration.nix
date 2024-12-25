{ pkgs, vars, ... }:

{
  # imports = (import ./modules);

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
      eza # Ls
      git # Version Control
      mas # Mac App Store $ mas search <app>
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
    ];
    masApps = {
      "Wireguard" = 1451685025;
    };
  };

  home-manager.users.${vars.user} = { config, ...}: {
    home.stateVersion = "22.05";
    home.file = {
      ".config/fish".source = config.lib.file.mkOutOfStoreSymlink "/Users/marius/dotfiles/fish";
      ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink "/Users/marius/dotfiles/wezterm";
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/Users/marius/dotfiles/nvim";
      ".config/aerospace".source = config.lib.file.mkOutOfStoreSymlink "/Users/marius/dotfiles/aerospace";
      ".config/neofetch".source = config.lib.file.mkOutOfStoreSymlink "/Users/marius/dotfiles/neofetch";
      ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "/Users/marius/dotfiles/starship.toml";
      ".config/qBittorrent".source = config.lib.file.mkOutOfStoreSymlink "/Users/marius/dotfiles/qBittorrent";
      ".config/nix-darwin".source = config.lib.file.mkOutOfStoreSymlink "/Users/marius/dotfiles/nix-darwin";
      ".config/nix".source = config.lib.file.mkOutOfStoreSymlink "/Users/marius/dotfiles/nix";
      ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink "/Users/marius/dotfiles/yazi";
      ".config/eza".source = config.lib.file.mkOutOfStoreSymlink "/Users/marius/dotfiles/eza";
    };
    home.sessionPath = [
      "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
    ];
    programs.fish.enable = true;
    programs.home-manager.enable = true;
  };

  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nix;
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      # auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  system = {
    stateVersion = 4;
  };
}
