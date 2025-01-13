{ lib, config, ... }:
{
  imports = [
    ./binds.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./main.nix
  ];

  options = {
    hyprland.enable = lib.mkEnableOption "enables hyprland";
  };
}
