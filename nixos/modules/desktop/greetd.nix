{ pkgs, lib, config, ... }:
{
  options = {
    greetd.enable = lib.mkEnableOption "enables greetd";
  };

  config = lib.mkIf config.greetd.enable {
    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${pkgs.sway}/bin/sway";
          user = "${vars.user}";
        };
        default_session = initial_session;
      };
    };

    environment.etc."greetd/environments".text = ''
      sway
    '';
  };
}
