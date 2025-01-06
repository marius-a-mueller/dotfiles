{ ... }:
{
  # Provisioning
  # nix run github:nix-community/nixos-anywhere -- --flake .#helms-deep --target-host marius@<ip address> --build-on-remote
  # Upgrading
  # nixos-rebuild switch --flake .#helms-deep --target-host "root@<ip address>"

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

  system.stateVersion = "24.11";
}
