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
      currentSystem = builtins.currentSystem;
      pkgs = import inputs.nixpkgs { system = currentSystem; };
    in
    {
      nixosConfigurations = (
        import ./hosts/nixos {
          inherit (inputs.nixpkgs) lib;
          inherit inputs vars;
        }
      );

      darwinConfigurations = (
        import ./hosts/darwin {
          inherit (inputs.nixpkgs) lib;
          inherit inputs vars;
        }
      );

      devShells.aarch64-darwin.default = let
          pkgs = import inputs.nixpkgs { system = "aarch64-darwin"; config.allowUnfree = true; };
        in
          pkgs.mkShell {
            buildInputs = with pkgs; [
              # (terraform.withPlugins (p: [ p.null p.external p.proxmox ]))
              nixos-rebuild
            ];
          };

      # homeConfigurations = (
      #   import ./nix {
      #     inherit (nixpkgs) lib;
      #     inherit inputs nixpkgs nixpkgs-stable home-manager nixgl vars;
      #   }
      # );
    };
}
