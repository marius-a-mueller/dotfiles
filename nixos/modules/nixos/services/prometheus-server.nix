{ lib, config, ... }:
{
  options = {
    prometheus-server.enable = lib.mkEnableOption "enables prometheus-server";
  };
  config = lib.mkIf config.prometheus-server.enable {
    # https://wiki.nixos.org/wiki/Prometheus
    # https://nixos.org/manual/nixos/stable/#module-services-prometheus-exporters-configuration
    # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/monitoring/prometheus/default.nix
    services.prometheus = {
      enable = true;
      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets = [
                "127.0.0.1:9100"
              ];
              labels = {
                hostname = "monitoring";
              };
            }
            {
              targets = [
                "192.168.42.214:9100"
              ];
              labels = {
                hostname = "the-shire";
              };
            }
            {
              targets = [
                "192.168.42.212:9100"
              ];
              labels = {
                hostname = "gringotts";
              };
            }
          ];
        }
      ];
    };
  };
}
