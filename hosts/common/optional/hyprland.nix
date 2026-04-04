{ pkgs, ... }:
let
  # sway-kiosk = command: "${lib.getExe pkgs.sway} --unsupported-gpu --config ${pkgs.writeText "kiosk.config" ''
  #   output * bg #000000 solid_color
  #   xwayland disable
  #   input "type:touchpad" {
  #     tap enabled
  #   }
  #   exec '${vars} ${command}; ${pkgs.sway}/bin/swaymsg exit'
  # ''}";
  # Criamos o arquivo de config do Hyprland para o greeter via Nix
  hyprlandGreeterConf = pkgs.writeText "hyprland-greeter.conf" ''
    # Ajuste aqui conforme seus monitores
    # Se quiser as duas telas ligadas, mas o ReGreet só em uma:
    # monitor=HDMI-A-1, 1920x1080@60, 0x0, 1
    # monitor=DP-1, 2560x1440@144, 1920x0, 1

    # Dica: Desativar a tela secundária no login evita o bug de centralização
    monitor=, preferred, auto, 1, mirror, eDP-1

    exec-once = ${pkgs.regreet}/bin/regreet; hyprctl dispatch exit
    windowrule = fullscreen on, class:^(regreet)$
    windowrule = center on, class:^(regreet)$
  '';
in
{

  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };

  # services.xserver = {
  #   enable = true;
  #   displayManager.lightdm.enable = true;
  # };

  environment.systemPackages = with pkgs; [
    kitty # required for the default Hyprland config
    adwaita-icon-theme
    gnome-themes-extra # Optional: for extra GTK theme support
  ];

  security.pam.services.hyprlock = { };

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # networking.wireless = {
  #   enable = true;
  # };

  programs.regreet = {
    enable = true;
    theme.name = "Adwaita";
    font = {
      name = "Cantarell";
      size = 16;
    };
    cursorTheme.name = "Adwaita";
  };
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Mudamos o comando para iniciar o Hyprland com a config específica
        command = "${pkgs.hyprland}/bin/Hyprland --config ${hyprlandGreeterConf}";
        user = "greeter";
      };
    };
    # settings.default_session.command = sway-kiosk (lib.getExe config.programs.regreet.package);
  };

  # services.displayManager.sddm = {
  #   enable = true;
  #   wayland.enable = true;
  # };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };
}
