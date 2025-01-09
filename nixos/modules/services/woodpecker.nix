{ lib, config, ... }:
let domain = "woodpecker.mindful-student.net";
in {
  options = {
    woodpecker.enable = lib.mkEnableOption "woodpecker";
  };
  config = lib.mkIf config.woodpecker.enable {
    services.woodpecker-server = {
      enable = true;
      environment = {
        WOODPECKER_HOST = "${domain}";
        WOODPECKER_OPEN = "true";
        WOODPECKER_GITEA = "true";
        WOODPECKER_GITEA_CLIENT = "ffffffff-ffff-ffff-ffff-ffffffffffff";
        WOODPECKER_GITEA_URL = "https://git.example.com";
      };
    };
    services.woodpecker-agents.agents."smith" = {
      enabled = true;
      environment = {
        WOODPECKER_SERVER = "localhost:9000";
        WOODPECKER_BACKEND = "docker";
        DOCKER_HOST = "unix:///run/podman/podman.sock";
      };
    };
  };
}
