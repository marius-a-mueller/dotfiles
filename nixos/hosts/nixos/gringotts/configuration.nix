{ ... }:
{
  # Provisioning
  # nix run github:nix-community/nixos-anywhere -- --flake .#helms-deep --target-host marius@<ip address> --build-on-remote
  # Upgrading (with custom fish function)
  # nixos-deploy .#helms-deep marius@<ip address>

  imports = [
    ./hardware-configuration.nix
  ];

  disko.enable = true;
  nginx.enable = true;
  shiori.enable = true;
  vaultwarden.enable = true;
  metrics-exporter.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };
  networking.networkmanager.ethernet.macAddress = "bc:24:11:5b:0c:1b";

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
