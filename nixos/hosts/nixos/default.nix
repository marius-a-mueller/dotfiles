{ inputs, nixpkgs, nixpkgs-stable, nixos-hardware, home-manager, disko, nur, hyprland, hyprspace, plasma-manager, jovian, vars, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  stable = import nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  couchcomputer = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system stable jovian vars;
      host = {
        hostName = "couchcomputer";
      };
    };
    modules = [
      ./couchcomputer
      ./configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

  nixflix = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system stable vars;
      host = {
        hostName = "nixflix";
      };
    };
    modules = [
      disko.nixosModules.disko
      ./nixflix
      ./configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
