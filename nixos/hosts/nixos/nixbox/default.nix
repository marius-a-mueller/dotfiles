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
}
