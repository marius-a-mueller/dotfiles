{ lib, ... }:
{
  imports = [
    ./firefox.nix
    ./steam
    ./wireguard.nix
    ./tailscale.nix
  ];
}
