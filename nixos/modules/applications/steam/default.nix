{ config, pkgs, inputs, lib, vars, ... }:
{
  options = {
    steam.enable = lib.mkEnableOption "enables steam and proton";
  };

  config = lib.mkIf config.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    environment.systemPackages = with pkgs; [
      mangohud # performance monitoring
      protonup-qt # multiple proton versions
      lutris
      # bottles
      heroic # use proton for non steam games
    ];
  };
}
