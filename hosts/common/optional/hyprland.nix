{
  inputs,
  pkgs,
  ...
}:
# let
#   packageNames = map (p: p.pname or p.name or null) config.home.packages;
#   hasPackage = name: lib.any (x: x == name) packageNames;
#   hasHyprshutdown = hasPackage "hyprshutdown";
#   # Criamos o arquivo de config do Hyprland para o greeter via Nix
#   hyprlandGreeterConf = pkgs.writeText "hyprland-greeter.conf" ''
#     # Ajuste aqui conforme seus monitores
#     # Se quiser as duas telas ligadas, mas o ReGreet só em uma:
#     # monitor=HDMI-A-1, 1920x1080@60, 0x0, 1
#     # monitor=DP-1, 2560x1440@144, 1920x0, 1

#     # Dica: Desativar a tela secundária no login evita o bug de centralização
#     monitor=, highres@auto, auto, 1, mirror

#     exec-once = ${pkgs.regreet}/bin/regreet; hyprshutdown
#     windowrule = fullscreen on, match:class ^(regreet)$
#     windowrule = center on, match:class ^(regreet)$
#   '';
# in
{

  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };

  environment.systemPackages = with pkgs; [
    kitty # required for the default Hyprland config
    hyprshutdown
    pkgs.magnetic-catppuccin-gtk
    gnome-themes-extra # Optional: for extra GTK theme support
  ];

  # security.pam.services.hyprlock = { };

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  programs.noctalia-greeter = {
    enable = true;

    # Optional configuration
    greeter-args = "";
    settings = {
      cursor = {
        theme = "Catppuccin-GTK-Dark";
        size = 24;
        path = "${pkgs.catppuccin-cursors.macchiatoDark}/share/icons";
      };
      keyboard = {
        layout = "us";
      };
    };
  };

  #  programs.regreet = {
  #    enable = true;
  #    theme.name = "Adwaita";
  #    font = {
  #      name = "Cantarell";
  #      size = 16;
  #    };
  #    cursorTheme.name = "Adwaita";
  #  };
  #  services.greetd = {
  #    enable = true;
  #    settings = {
  #      default_session = {
  # Mudamos o comando para iniciar o Hyprland com a config específica
  #        command = "${pkgs.hyprland}/bin/Hyprland --config ${hyprlandGreeterConf}";
  #        user = "greeter";
  #      };
  #    };
  # settings.default_session.command = sway-kiosk (lib.getExe config.programs.regreet.package);
  #  };

  #  services.displayManager.sddm = {
  #    enable = true;
  #    wayland.enable = true;
  #  };

  # services.displayManager = {
  #   defaultSession = "hyprland-uwsm";
  #   ly = {
  #     enable = true;
  #     # Configurações adicionais do Ly (opcional)
  #     settings = {
  #       animation = "matrix"; # Efeito visual no login
  #       save = true; # Salva o último usuário e sessão usados
  #       bigclock = true; # Hora grande no login
  #     };
  #   };
  # };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };
}
