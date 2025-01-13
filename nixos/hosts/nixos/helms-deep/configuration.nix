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
  headscale.enable = true;
  searx.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

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
