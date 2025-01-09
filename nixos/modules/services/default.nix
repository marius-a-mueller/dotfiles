{ ... }:
{
  imports = [
    ./headscale.nix
    ./forgejo.nix
    ./woodpecker.nix
    ./privatebin.nix
    ./searx
  ];

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
}
