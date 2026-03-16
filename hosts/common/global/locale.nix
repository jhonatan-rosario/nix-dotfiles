{lib, ...}: {
  i18n = {
    defaultLocale = lib.mkDefault "pt_BR.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };
    supportedLocales = lib.mkDefault [
      "pt_BR.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };

  location.provider = "geoclue2";
  time.timeZone = lib.mkDefault "America/Sao_Paulo";

  services.xserver = {
    xkb.layout = "us,br";
    xkb.variant = "alt-intl";
    xkb.options = "grp:alt_shift_toggle";
    exportConfiguration = true;
  };
}
