{ lib, pkgs, vars, ...}:
{
  imports = [
    ./hardware-configuration.nix
    ../../../modules
  ];

  steam.enable = true;
  firefox.enable = true;
  wireguard.enable = true;

  # https://medium.com/@notquitethereyet_/gaming-on-nixos-%EF%B8%8F-f98506351a24
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = true;
  # nix shell nixpkgs#pciutils -c lspci | grep VGA
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true; # Lets you use `nvidia-offload %command%` in steam
    };

    intelBusId = "PCI:00:02:0";
    # amdgpuBusId = "PCI:0:0:0";
    nvidiaBusId = "PCI:01:00:0";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = lib.mkForce "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      firefox
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "${vars.user}";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = lib.mkForce "25.05"; # Did you read the comment?
}
