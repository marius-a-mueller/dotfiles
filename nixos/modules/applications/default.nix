{ lib, ... }:
{
  imports = [
    ./firefox
    ./steam
    ./wireguard.nix
  ];
}
