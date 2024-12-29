{ config, vars, ... }:
{
  home = {
    stateVersion = "22.05";
    sessionPath = [
      "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
    ];
  };
  xdg.configFile = {
    "fish".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.user}/dotfiles/fish";
    "wezterm".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.user}/dotfiles/wezterm";
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.user}/dotfiles/nvim";
    "starship.toml".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.user}/dotfiles/starship.toml";
    "yazi".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.user}/dotfiles/yazi";
    "eza".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.user}/dotfiles/eza";
  };
  programs = {
    home-manager.enable = true;
  };
}
