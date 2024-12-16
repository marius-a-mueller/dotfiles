{ config, pkgs, ... }:

{
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
        fish_vi_key_bindings
        starship init fish | source
      '';
      shellAliases = {
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";
        mkdir = "mkdir -p";
      };
      shellAbbrs = {
        g = "git";
        m = "make";
        n = "nvim";
        o = "open";
        p = "python3";
      };
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
