{ ... }:
{
  imports = [
    ./headscale.nix
    ./forgejo.nix
    ./woodpecker.nix
    ./privatebin.nix
    ./searx.nix
    ./nginx.nix
  ];
}