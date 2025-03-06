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
    ./shiori.nix
    ./homepage.nix
    ./overleaf.nix
    ./wallabag.nix
    ./pangolin-server.nix
    ./pangolin-newt.nix
  ];
}
