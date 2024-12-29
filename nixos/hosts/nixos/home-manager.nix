{ config, vars, ... }:
{
  home = {
    stateVersion = "22.05";
    sessionPath = [
      "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
    ];
    file = {
      ".config/fish".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.user}/dotfiles/fish";
      ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.user}/dotfiles/wezterm";
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.user}/dotfiles/nvim";
      ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.user}/dotfiles/starship.toml";
      ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.user}/dotfiles/yazi";
      ".config/eza".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.user}/dotfiles/eza";
    };
  };
  programs = {
    home-manager.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
    };
    fish = {
      enable = true;
    };
  };
}
