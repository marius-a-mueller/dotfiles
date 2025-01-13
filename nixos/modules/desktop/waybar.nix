{ inputs, lib, config, vars, ... }: {
  options = {
    waybar.enable = lib.mkEnableOption "waybar";
  };

  config = lib.mkIf config.waybar.enable {
    home-manager.users.${vars.user} = { pkgs, ... }: {
      programs.waybar.enable = true;
    };
  };
}
