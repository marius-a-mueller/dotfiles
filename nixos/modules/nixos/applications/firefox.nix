{ config, pkgs, lib, ... }:
{
  config = lib.mkIf config.firefox.enable {
    environment = {
      systemPackages = with pkgs; [
        firefox
      ];
    };
  };
}
