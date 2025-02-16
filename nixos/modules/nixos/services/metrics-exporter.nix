{ lib, config, ... }:
{
  options = {
    metrics-exporter.enable = lib.mkEnableOption "enables exporting metrics";
  };
  config = lib.mkIf config.metrics-exporter.enable {
    services.prometheus.exporters.node = {
      enable = true;
      port = 9100;
      enabledCollectors = [
        "logind"
        "systemd"
      ];
      disabledCollectors = [
        "textfile"
      ];
      openFirewall = true;
      firewallFilter = "-i ens18 -p tcp -m tcp --dport 9100";
    };
  };
}
