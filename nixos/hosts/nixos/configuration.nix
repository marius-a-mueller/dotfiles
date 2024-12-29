{ lib, config, pkgs, stable, inputs, vars, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  networking.hostName = lib.mkDefault "nixos";
  # Enable networking
  networking.networkmanager.enable = true;

  services.qemuGuest.enable = lib.mkDefault true; # Enable QEMU Guest for Proxmox
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
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkDefault "us";
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
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ]; # Allow remote updates
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
  nixpkgs.config.allowUnfree = true;

  system = {
    # autoUpgrade = {
    #   enable = true;
    #   channel = "https://nixos.org/channels/nixos-unstable";
    # };
    stateVersion = lib.mkDefault "22.05";
  };

  home-manager.backupFileExtension = "backup";
  home-manager.users.${vars.user} = { config, ...}: {
    home = {
      stateVersion = lib.mkDefault "22.05";
      sessionPath = [
        "/run/current-system/sw/bin"
        "$HOME/.nix-profile/bin"
      ];
      file = {
        ".config/fish".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.user}/dotfiles/fish";
        ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.user}/dotfiles/wezterm";
        ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.user}/dotfiles/nvim";
        ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.user}/dotfiles/starship.toml";
        ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.user}/dotfiles/yazi";
        ".config/eza".source = config.lib.file.mkOutOfStoreSymlink "/home/${vars.user}/dotfiles/eza";
      };
    };
    programs = {
      home-manager.enable = true;
      neovim = {
        enable = true;
        defaultEditor = true;
        vimAlias = true;
        viAlias = true;
      };
      fish = {
        enable = true;
      };
    };
  };
}
