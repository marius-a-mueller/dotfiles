{ pkgs, ... }:
{
  options = {
    greetd.enable = lib.mkEnableOption "enables greetd";
  };

  config = lib.mkIf config.greetd.enable {
    services.greetd = {
      enable = true;
      settings = {
       default_session.command = ''
        ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --time \
          --asterisks \
          --user-menu \
          --cmd sway
      '';
      };
    };

    environment.etc."greetd/environments".text = ''
      sway
    '';
  };
}
