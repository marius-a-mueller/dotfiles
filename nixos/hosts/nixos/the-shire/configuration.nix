{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  disko.enable = true;
  nginx.enable = true;
  shiori.enable = true;
  homepage.enable = true;
  metrics-exporter.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };
  networking.networkmanager.ethernet.macAddress = "bc:24:11:5b:0c:2d";

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

  system.stateVersion = "24.11";
}
