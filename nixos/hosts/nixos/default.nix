{ inputs, vars, lib, ... }:
let
  system = "x86_64-linux";

  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  stable = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  couchcomputer = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs pkgs lib system vars;
      host = {
        hostName = "couchcomputer";
      };
    };
    modules = [
      ./couchcomputer
      ./configuration.nix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

  helms-deep = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs pkgs lib system vars;
      host = {
        hostName = "helms-deep";
      };
    };
    modules = [
      ./helms-deep
      ./configuration.nix
      inputs.disko.nixosModules.disko
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

  nixbox = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs pkgs lib system vars;
      host = {
        hostName = "nixbox";
      };
    };
    modules = [
      ./nixbox
      ./configuration.nix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

  nixflix = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs pkgs lib system vars;
      host = {
        hostName = "nixflix";
      };
    };
    modules = [
      # disko.nixosModules.disko
      ./nixflix
      ./configuration.nix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
