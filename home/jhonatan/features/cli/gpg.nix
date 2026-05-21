{
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.gcr ]; # fix: pinentry-gnome3

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    # sshKeys = [ ];
    enableExtraSocket = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };

  programs =
    let
      fixGpg = /* bash */ ''
        gpgconf --launch gpg-agent
      '';
    in
    {
      # Start gpg-agent if it's not running or tunneled in
      # SSH does not start it automatically, so this is needed to avoid having to use a gpg command at startup
      # https://www.gnupg.org/faq/whats-new-in-2.1.html#autostart
      fish.loginShellInit = fixGpg;

      gpg = {
        enable = true;
      };
    };

  home.persistence."/persist".directories = [
    {
      directory = ".gnupg";
      mode = "0700";
    }
  ];
}
