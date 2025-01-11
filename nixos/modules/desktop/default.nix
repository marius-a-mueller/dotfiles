{ lib, ... }:
{
  imports = [
    ./tuigreet.nix
    ./hyprland.nix
    ./wayland.nix
  ];
}
