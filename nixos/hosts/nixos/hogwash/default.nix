{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../../modules
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/sda";

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

  environment = {
    systemPackages = with pkgs; [
      zig
    ];
  };
  # networking.networkmanager.ethernet.macAddress = "bc:24:11:36:c7:8e";
  systemd.targets.hibernate.enable = false;

  system.stateVersion = "24.11"; # Did you read the comment?
}
