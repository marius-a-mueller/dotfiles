{ lib, config, ... }: {
  options = {
    nginx.enable = lib.mkEnableOption "nginx";
  };

  config = lib.mkIf config.nginx.enable {
    services.nginx = {
      enable = true;
      logError = "stderr debug";
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "acme@mindful-student.net";
    };
  };
}
