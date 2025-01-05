{ lib, ... }:
{
  imports = [
    ./greetd.nix
    ./hyprland.nix
    ./wayland.nix
  ];
}
