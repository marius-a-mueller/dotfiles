{
  description = "Nix, NixOS and Nix Darwin System Flake Configuration";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
      nixos-hardware.url = "github:nixos/nixos-hardware/master";

      disko = {
        url = "github:nix-community/disko/latest";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # User Environment Manager
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # Stable User Environment Manager
      home-manager-stable = {
        url = "github:nix-community/home-manager/release-23.11";
        inputs.nixpkgs.follows = "nixpkgs-stable";
      };

      # MacOS Package Management
      darwin = {
        url = "github:lnl7/nix-darwin/master";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # NUR Community Packages
      nur = {
        url = "github:nix-community/NUR";
        # Requires "nur.nixosModules.nur" to be added to the host modules
      };

      firefox-addons = {
        url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      sops-nix = {
        url = "github:Mic92/sops-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # Fixes OpenGL With Other Distros.
      nixgl = {
        url = "github:guibou/nixGL";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # Official Hyprland Flake
      hyprland = {
        url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      };

      # Hyprspace
      hyprspace = {
        url = "github:KZDKM/Hyprspace";
        inputs.hyprland.follows = "hyprland";
      };

      # KDE Plasma User Settings Generator
      plasma-manager = {
        url = "github:pjones/plasma-manager";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { ... }:
    let
      # Variables Used In Flake
      vars = {
        user = "marius";
        terminal = "wezterm";
        editor = "nvim";
      };

      systemConfig = system: {
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        stable = import inputs.nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      mkNixosConfiguration = {
        hostname,
        system ? "x86_64-linux",
        }: let
          inherit (systemConfig system) pkgs stable;
        in
          inputs.nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit inputs hostname pkgs vars stable;
            };
            modules = [
              ./hosts/nixos/configuration.nix
              ./hosts/nixos/${hostname}/configuration.nix
              ./modules/shared
              ./modules/nixos
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
              }
              inputs.disko.nixosModules.disko
            ];
          };

      mkDarwinConfiguration = {
        hostname,
        system ? "aarch64-darwin",
        }: let
          inherit (systemConfig system) pkgs stable;
        in
          inputs.darwin.lib.darwinSystem {
            inherit system;
            specialArgs = {
              inherit inputs hostname pkgs vars stable;
            };
            modules = [
              ./hosts/darwin/configuration.nix
              ./hosts/darwin/${hostname}/configuration.nix
              ./modules/shared
              ./modules/darwin
              inputs.home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
              }
              # inputsnix-homebrew.darwinModules.nix-homebrew
            ];
          };

    in
    {
      nixosConfigurations = {
        nixflix       = mkNixosConfiguration { hostname = "nixflix"; };
        couchcomputer = mkNixosConfiguration { hostname = "couchcomputer"; };
        helms-deep    = mkNixosConfiguration { hostname = "helms-deep"; };
        hogwash       = mkNixosConfiguration { hostname = "hogwash"; };
        nixbox        = mkNixosConfiguration { hostname = "nixbox"; };
        gringotts     = mkNixosConfiguration { hostname = "gringotts"; };
        eye-of-sauron = mkNixosConfiguration { hostname = "eye-of-sauron"; };
      };

      darwinConfigurations = {
        MacBook       = mkDarwinConfiguration { hostname = "MacBook"; };
      };

      devShells.aarch64-darwin.default = let
          pkgs = import inputs.nixpkgs { system = "aarch64-darwin"; config.allowUnfree = true; };
        in
          pkgs.mkShell {
            buildInputs = with pkgs; [
              # (terraform.withPlugins (p: [ p.null p.external p.proxmox ]))
              nixos-rebuild
            ];
          };
    };
}
