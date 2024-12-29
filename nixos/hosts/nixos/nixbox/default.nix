{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      (terraform.withPlugins (p: [ p.null p.external p.proxmox ]))
    ];
  };
  networking.networkmanager.ethernet.macAddress = "bc:24:11:36:c7:8e";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  system.stateVersion = "24.11"; # Did you read the comment?
}
