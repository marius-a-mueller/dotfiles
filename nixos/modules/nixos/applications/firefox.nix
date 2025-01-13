{ config, pkgs, lib, ... }:
{
  options = {
    firefox.enable = lib.mkEnableOption "firefox";
  };
  config = lib.mkIf config.firefox.enable {
    environment = {
      systemPackages = with pkgs; [
        firefox
      ];
    };
  };
}
