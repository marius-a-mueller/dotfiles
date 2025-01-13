{ pkgs, lib, config, ... }: {
  options = {
    wayland.enable = lib.mkEnableOption "enables wayland";
  };

  config = lib.mkIf config.wayland.enable {
    hardware.graphics.enable = true;

    # audio
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    # xdg.portal.wlr.enable = true;
    # xdg.portal.configPackages = [ pkgs.gnome-session ];
    # services.dbus.enable = true;
  };
}
