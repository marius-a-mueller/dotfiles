{ lib, ... }:
{
  imports = [
    ./tuigreet.nix
    ./swaync.nix
    # ./wayland.nix
    ./wofi
    # ./hyprland
    ./waybar
  ];
}
