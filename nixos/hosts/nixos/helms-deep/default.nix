{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../../modules/disko
  ];

  programs = {
    fish.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
    };
    yazi.enable = true;
    starship.enable = true;
  };

  disko.enable = true;

  system.stateVersion = "24.11"; # Did you read the comment?
}
