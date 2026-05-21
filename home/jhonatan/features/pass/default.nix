{
  pkgs,
  config,
  ...
}:
let
  storePath = "${config.home.homeDirectory}/.password-store";
in
{
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = storePath;
    };
    package = pkgs.pass.withExtensions (p: [ p.pass-otp ]);
  };

  services.pass-secret-service = {
    enable = true;
    storePath = storePath;
  };

  home.persistence = {
    "/persist".directories = [ ".password-store" ];
  };
}
