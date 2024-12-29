{ inputs, lib, vars, ... }:

let
  systemConfig = system: {
    system = system;
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    stable = import inputs.nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  };
in
{
  MacBook =
    let
      inherit (systemConfig "aarch64-darwin") system pkgs stable;
    in
    inputs.darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit inputs pkgs vars lib; };
      modules = [
        ./darwin-configuration.nix
        ./MacBook.nix
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
}
