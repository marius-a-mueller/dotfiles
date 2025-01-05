{ pkgs, inputs, lib, config, vars, ... }: {
  options = {
    hyprland.enable = lib.mkEnableOption "enables hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    # # I kinda like the white cursor
    # home.sessionVariables = {
    #   WLR_NO_HARDWARE_CURSORS = 1;
    #   NIXOS_OZONE_WL = 1;
    # };

    home-manager.users.${vars.user} = { pkgs, ... }: {
      home.sessionVariables.NIXOS_OZONE_WL = "1";
      home.packages = with pkgs; [
        # utils
        acpi # hardware states
        brightnessctl # Control background
        playerctl # Control audio

        wayland.windowManager.hyprland = {
          enable = true;
          # set the flake package
          package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        };
        eww
        wl-clipboard
        rofi
        grim
        # from overlay
        mpvpaper
      ];
    };
  };
}
