{ pkgs, inputs, lib, config, ... }: {
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
      home.packages = with pkgs; [
        # utils
        acpi # hardware states
        brightnessctl # Control background
        playerctl # Control audio

        (inputs.hyprland.packages."x86_64-linux".hyprland.override {
          enableNvidiaPatches = true;
        })
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
