# home.nix
# home-manager switch

{ config, pkgs, inputs, ... }:

{
  home.username = "marius";
  home.homeDirectory = "/Users/marius";
  home.stateVersion = "23.05"; # Please read the comment before changing.

# Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = [
  ];

  imports = [
    ./firefox.nix
  ];

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

  # fix for firefox
  # https://github.com/nix-community/home-manager/pull/5801/files
  home.sessionVariables = {
    MOZ_LEGACY_PROFILES = 1;
    MOZ_ALLOW_DOWNGRADE = 1;
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];
  programs.home-manager.enable = true;
}
