{ vars, ... }:
{
  home-manager.users.${vars.user} = { ... }: {
    # Wallpaper is configured in ../stylix.nix
    services.hyprpaper = {
      enable = true;
    };
  };
}
