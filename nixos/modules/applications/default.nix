{ lib, ... }:
{
  imports = [
    ./firefox
    ./steam
    ./wireguard.nix
    ./tailscale.nix
  ];
}
