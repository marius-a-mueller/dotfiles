{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  disko.enable = true;
  nginx.enable = true;
  prometheus-server.enable = true;
  grafana.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };
  networking.networkmanager.ethernet.macAddress = "BC:24:11:F1:B4:30";

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
