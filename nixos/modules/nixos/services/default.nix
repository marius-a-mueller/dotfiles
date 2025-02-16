{ ... }:
{
  imports = [
    ./headscale.nix
    ./forgejo.nix
    ./woodpecker.nix
    ./privatebin.nix
    ./searx.nix
    ./nginx.nix
    ./vaultwarden.nix
    ./metrics-exporter.nix
    ./grafana.nix
    ./prometheus-server.nix
  ];
}
