{ lib, config, ... }:
{
  options = {
    metrics-exporter.enable = lib.mkEnableOption "enables exporting metrics";
  };
  config = lib.mkIf config.metrics-exporter.enable {
    services.prometheus.exporters = {
      node = {
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
      process = {
        enable = true;
        openFirewall = true;
        port = 9558;
        settings.process_names = [
          # Remove nix store path from process name
          # { name = "{{.Matches.Wrapped}}"; cmdline = [ "^/nix/store[^ ]*/(?P<Wrapped>[^ /]*) .*" ]; }
          # { name = "{{.Comm}}"; cmdline = [ ".+" ]; }
          { name = "{{.Cgroups}}"; cmdline = [ ".+" ]; }
        ];
      };
    };
  };
}
