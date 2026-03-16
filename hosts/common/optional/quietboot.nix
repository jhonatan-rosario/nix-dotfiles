{
  pkgs,
  config,
  ...
}: {
  console = {
    useXkbConfig = true;
    earlySetup = false;
  };

  boot = {
    # plymouth = {
    #   enable = true;
    #   theme = "spinner-monochrome";
    #   font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
    #   themePackages = [
    #     (pkgs.plymouth-spinner-monochrome.override {inherit (config.boot.plymouth) logo;})
    #   ];
    # };
    # original config
    plymouth = {
      enable = true;
      font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
      themePackages = with pkgs; [
        # catppuccin-plymouth
        # kdePackages.breeze-plymouth
        nixos-bgrt-plymouth
      ];
      theme = "nixos-bgrt";
    };
    loader.timeout = 0;
    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };
}
