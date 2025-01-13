{ lib, config, ... }:
{
  options = {
    hyprland.enable = lib.mkEnableOption "enables hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    imports = [
      ./binds.nix
      ./hypridle.nix
      ./hyprlock.nix
      ./hyprpaper.nix
      ./main.nix
    ];
  };
}
