{ config, pkgs, inputs, lib, vars, ... }:
{
  options = {
    steam.enable = lib.mkEnableOption "enables steam";
  };

  config = lib.mkIf config.steam.enable {
    home-manager.users.${vars.user} = {
      programs = {
        gamemode.enable = true;
        steam = {
          enable = true;
          gamescopeSession.enable = true;
        };
      };
      environment.systemPackages = with pkgs; [
        mangohud # performance monitoring
        protonup-qt # multiple proton versions
        lutris
        bottles
        heroic # use proton for non steam games
      ];
    };
  };
}