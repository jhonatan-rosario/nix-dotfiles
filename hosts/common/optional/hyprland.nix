{pkgs, ...}: let
  # sway-kiosk = command: "${lib.getExe pkgs.sway} --unsupported-gpu --config ${pkgs.writeText "kiosk.config" ''
  #   output * bg #000000 solid_color
  #   xwayland disable
  #   input "type:touchpad" {
  #     tap enabled
  #   }
  #   exec '${vars} ${command}; ${pkgs.sway}/bin/swaymsg exit'
  # ''}";
in {
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland.override {
      enableXWayland = true;
      withSystemd = true;
    };
  };

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
  };

  environment.systemPackages = [
    pkgs.kitty # required for the default Hyprland config
  ];

  security.pam.services.hyprlock = {};

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # networking.wireless = {
  #   enable = true;
  # };

  # programs.regreet = {
  #   enable = true;
  #   # iconTheme = gabrielCfg.gtk.iconTheme;
  #   # theme = gabrielCfg.gtk.theme;
  #   # font = gabrielCfg.fontProfiles.regular;
  #   # cursorTheme = {
  #   #   inherit (gabrielCfg.gtk.cursorTheme) name package;
  #   # };
  #   # settings.background = {
  #   #   path = gabrielCfg.wallpaper;
  #   #   fit = "Cover";
  #   # };
  # };
  # services.greetd = {
  #   enable = true;
  #   # settings.default_session.command = sway-kiosk (lib.getExe config.programs.regreet.package);
  # };
}
