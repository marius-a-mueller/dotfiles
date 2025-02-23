{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  disko.enable = true;
  nginx.enable = true;
  shiori.enable = true;
  homepage.enable = true;
  overleaf.enable = true;
  metrics-exporter.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };
  networking.networkmanager.ethernet.macAddress = "bc:24:11:5b:0c:2d";

  programs = {
    fish.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
    };
    yazi.enable = true;
    starship.enable = true;
  };

  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };


  system.stateVersion = "24.11";
}
