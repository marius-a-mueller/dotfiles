{ pkgs, lib, config, ... }: {
  options = {
    wireguard.enable = lib.mkEnableOption "enables wireguard";
  };

  config = lib.mkIf config.wireguard.enable {
    networking.wg-quick.interfaces.wg0.configFile = "/secrets/wg0.conf";
  };
}
