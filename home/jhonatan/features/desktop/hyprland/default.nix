{
  lib,
  config,
  pkgs,
  outputs,
  inputs,
  ...
}:
let
  getHostname = x: lib.last (lib.splitString "@" x);
  inherit (config.colorscheme) palette;
  rgb = color: "rgb(${lib.removePrefix "#" color})";
  rgba = color: alpha: "rgba(${lib.removePrefix "#" color}${alpha})";
in
{
  imports = [
    ../common
    ../common/wayland-wm
    ./basic-binds.nix
    ./hyprland-with-noctalia.nix
  ];

  home.packages = with pkgs; [
    grimblast
    hyprpicker
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = false;
    };

    settings = {
      general = {
        layout = "dwindle";

        "col.active_border" = rgb palette.base07;
        "col.inactive_border" = rgb palette.base04;

        border_size = 2;
        allow_tearing = true;
        resize_on_border = true;
      };

      windowrule = [
        "match:title ^(Picture-in-Picture)$, float on"
        "match:title ^(Picture-in-Picture)$, pin on"
        "match:title ^(Picture-in-Picture)$, size 730 430"
        "match:title ^(Picture in picture)$, float on"
        "match:title ^(Picture in picture)$, pin on"
        "match:title ^(Picture in picture)$, size 730 430"
        "match:class ^(xdg-desktop-portal-gtk)$, float on"
        "match:class ^(xdg-desktop-portal-gtk)$, size 1100 700"
      ];

      layerrule = [
        "animation fade, match:namespace hyprpicker"
        "animation fade, match:namespace selection"
      ];

      animations = {
        enabled = true;
        bezier = [
          "easein,0.1, 0, 0.5, 0"
          "easeinback,0.35, 0, 0.95, -0.3"

          "easeout,0.5, 1, 0.9, 1"
          "easeoutback,0.35, 1.35, 0.65, 1"

          "easeinout,0.45, 0, 0.55, 1"
        ];

        animation = [
          "fadeIn,1,3,easeout"
          "fadeLayersIn,1,3,easeoutback"
          "layersIn,1,3,easeoutback,slide"
          "windowsIn,1,3,easeoutback,slide"

          "fadeLayersOut,1,3,easeinback"
          "fadeOut,1,3,easein"
          "layersOut,1,3,easeinback,slide"
          "windowsOut,1,3,easeinback,slide"

          "border,1,3,easeout"
          "fadeDim,1,3,easeinout"
          "fadeShadow,1,3,easeinout"
          "fadeSwitch,1,3,easeinout"
          "windowsMove,1,3,easeoutback"
          "workspaces,1,2.6,easeoutback,slide"
        ];
      };

      exec-once = [
        "ghostty --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false"
      ];

      monitor = ", highres@highrr, auto, 1";

      group = {
        "col.border_active" = rgb palette.base07;
        "col.border_inactive" = rgb palette.base04;
        "col.border_locked_active" = rgb palette.base09;
        "col.border_locked_inactive" = rgb palette.base04;
        groupbar.font_size = 11;

        groupbar = {
          height = 8;
          render_titles = false;
          "col.active" = rgb palette.base0E;
          "col.inactive" = rgba palette.base0E "80"; # 50%
          "col.locked_active" = rgb palette.base09;
          "col.locked_inactive" = rgb palette.base04;
        };
      };

      binds = {
        movefocus_cycles_fullscreen = false;
      };

      cursor.inactive_timeout = 4;
      input = {
        kb_layout = config.home.keyboard.layout;
        kb_variant = config.home.keyboard.variant;
        kb_options = config.home.keyboard.options;
        numlock_by_default = true;
        follow_mouse = 2;
        float_switch_override_focus = 2;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
        };
      };

      device = [
        {
          name = "royal-kludge-rk84";
          kb_layout = "us_intl";
        }
      ];

      dwindle = {
        split_width_multiplier = 1.35;
        pseudotile = true;
      };

      misc = {
        vfr = true;
        close_special_on_empty = true;
        focus_on_activate = true;
        key_press_enables_dpms = true;
        # Unfullscreen when opening something
        on_focus_under_fullscreen = 2;
      };

      bind =
        let
          grimblast = lib.getExe pkgs.grimblast;
        in
        [
          # Switch keyboard layout
          "SUPER,SPACE,exec,hyprctl switchxkblayout all next"

          # Hyprpicker
          "SUPERSHIFT,c,exec,hyprpicker -a"

          # Screenshotting
          ",Print,exec,${grimblast} --notify --freeze copy area"
          "SHIFT,Print,exec,${grimblast} --notify --freeze copy output"
        ];

      extraConfig = ''
        # Passthrough mode (e.g. for VNC)
        bind=SUPER,P,submap,passthrough
        submap=passthrough
        bind=SUPER,P,submap,reset
        submap=reset
      '';
    };
  };
}
