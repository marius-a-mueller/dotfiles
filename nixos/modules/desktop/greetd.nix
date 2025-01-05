{ pkgs, lib, config, vars, ... }:
{
  options = {
    greetd.enable = lib.mkEnableOption "enables greetd";
  };

  config = lib.mkIf config.greetd.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --greeting 'Welcome to NixOS!' --cmd sway";
          user = "${vars.user}";
        };
        initial_session = {
          command = "${pkgs.sway}/bin/sway";
          user = "${vars.user}";
        };
      };
    };

    environment.etc."greetd/environments".text = ''
      sway
    '';
  };
}
