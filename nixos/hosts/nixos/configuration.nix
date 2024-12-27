{ lib, config, pkgs, stable, inputs, vars, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  networking.hostName = lib.mkDefault "base";
  security.sudo.wheelNeedsPassword = false; # Don't ask for password

  services.qemuGuest.enable = lib.mkDefault true; # Enable QEMU Guest for Proxmox
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
  programs.ssh.startAgent = true;

  users.users.${vars.user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL7XFXNnqgxmbNFMx6rhc9gK8DAFCRHmIj9d9zQ+D/2l marius"
    ];
  };

  time.timeZone = "Europe/Berlin";
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  fonts.packages = with pkgs; [
    carlito # NixOS
    vegur # NixOS
    nerd-fonts.fira-code
    nerd-fonts.iosevka
  ];

  environment = {
    variables = {
      TERMINAL = "${vars.terminal}";
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };
    systemPackages = with pkgs; [
      # Terminal
      btop # Resource Manager
      cifs-utils # Samba
      coreutils # GNU Utilities
      git # Version Control
      lshw # Hardware Config
      wget # Retriever
    ];
  };

  services = {
    openssh = {
      enable = true;
      allowSFTP = true;
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      '';
    };
  };

  nix = {
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    # package = pkgs.nixVersions.latest;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  trusted-users = [ "root" "@wheel" ]; # Allow remote updates
  nixpkgs.config.allowUnfree = true;

  system = {
    # autoUpgrade = {
    #   enable = true;
    #   channel = "https://nixos.org/channels/nixos-unstable";
    # };
    stateVersion = "22.05";
  };

  home-manager.users.${vars.user} = {
    home = {
      stateVersion = "22.05";
    };
    programs = {
      home-manager.enable = true;
    };
  };
}
