{ lib, pkgs, vars, ...}:
{
  imports = [
    ./hardware-configuration.nix
    ../../../modules
  ];

  # tailscale.enable = true;
  steam.enable = true;
  firefox.enable = true;
  tuigreet.enable = true;
  wayland.enable = true;
  hyprland.enable = true;

  # nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.package = pkgs.linuxKernel.packages.linux_6_6.nvidia_x11;
  hardware.nvidia.modesetting.enable = true;
  # hardware.nvidia.prime.offload.enable = true;
  # something broke though
  # services.xserver.dpi = 110;
  # environment.variables = { GDK_SCALE = "0.3"; };

  # You must configure `hardware.nvidia.open` on NVIDIA driver versions >= 560.
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

  # # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # # Configure keymap in X11
  # services.xserver.xkb = {
  #   layout = "de";
  #   variant = "";
  # };

  # Configure console keymap
  console.keyMap = lib.mkForce "de";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.

  # environment = {
  #   systemPackages = with pkgs; [
  #   ];
  # };

  # Enable automatic login for the user.
  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "${vars.user}";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = lib.mkForce "25.05"; # Did you read the comment?
}
