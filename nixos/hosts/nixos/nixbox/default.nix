{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
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

  environment = {
    systemPackages = with pkgs; [
      (terraform.withPlugins (p: [ p.null p.external p.proxmox ]))
      zig
    ];
  };
  networking.networkmanager.ethernet.macAddress = "bc:24:11:36:c7:8e";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  system.stateVersion = "24.11"; # Did you read the comment?
}
