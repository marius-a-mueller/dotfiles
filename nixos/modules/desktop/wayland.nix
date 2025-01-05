{ lib, config, ... }: {
  options = {
    wayland.enable = lib.mkEnableOption "enables wayland";
  };

  config = lib.mkIf config.wayland.enable {
    hardware.opengl.enable = true;

    # audio
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    xdg.portal.wlr.enable = true;
    services.dbus.enable = true;
  };
}
