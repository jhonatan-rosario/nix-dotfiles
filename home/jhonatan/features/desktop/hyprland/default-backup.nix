{
  lib,
  config,
  pkgs,
  ...
}:
let
  # getHostname = x: lib.last (lib.splitString "@" x);
  # remoteColorschemes =
  #   lib.mapAttrs' (n: v: {
  #     name = getHostname n;
  #     value = v.config.colorscheme.rawColorscheme.colors.${config.colorscheme.mode};
  #   })
  #   outputs.homeConfigurations;
  inherit (config.colorscheme) palette;
  rgb = color: "rgb(${lib.removePrefix "#" color})";
  rgba = color: alpha: "rgba(${lib.removePrefix "#" color}${alpha})";
in
{
  imports = [
    ../common
    ../common/wayland-wm
    ./basic-binds.nix

    # ./hyprpaper.nix
    # ./hyprlock.nix
    # ./hypridle.nix
  ];

  home.packages = with pkgs; [
    grimblast
    hyprpicker
    easyeffects
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = false;
    };

    settings = {
      general = {
        "col.active_border" = rgb palette.base07;
        "col.inactive_border" = rgb palette.base04;

        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        allow_tearing = true;
        layout = "dwindle";
        resize_on_border = true;
      };

      exec-once = [
        # "hyprpaper"
        # "swayosd-server"
        "noctalia-shell"
        "ghostty --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false"
        # "wl-paste --type text --watch cliphist store" # Stores only text data
      ];

      monitor = ", highres@highrr, auto, 1";

      cursor.inactive_timeout = 4;
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

      input = {
        kb_layout = config.home.keyboard.layout;
        kb_variant = config.home.keyboard.variant;
        kb_options = config.home.keyboard.options;
        numlock_by_default = true;
        follow_mouse = 2;
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
      };

      misc = {
        vfr = true;
        close_special_on_empty = true;
        focus_on_activate = true;
        key_press_enables_dpms = true;
        # Unfullscreen when opening something
        on_focus_under_fullscreen = 2;
      };

      # windowrule =
      #   let
      #     xembedsniproxy = "class:^()$,title:^()$,xwayland:1,floating:1";
      #     anydesk = "class:^(Anydesk)$,title:^(anydesk)$";
      #   in
      #   [
      #     "float, ${anydesk}"
      #     "noblur, ${xembedsniproxy}"
      #   ];
      # ++ (lib.mapAttrsToList (name: colors:
      #   "bordercolor ${rgba colors.primary "aa"} ${rgba colors.primary_container "aa"}, title:^(\\[${name}\\])"
      # ) remoteColorschemes);

      layerrule = [
        # OLD
        # "noanim, ^(volume_osd)$"
        # "noanim, ^(brightness_osd)$"
        # "noanim, hyprpicker"

        # "animation fade, match:namespace hyprpicker"
        # "animation fade, match:namespace selection"

        # "animation fade, match:namespace waybar"
        # "blur on, match:namespace waybar"
        # "ignore_alpha 0, match:namespace waybar"

        # "blur on, match:namespace notifications"
        # "ignore_alpha 0, match:namespace notifications"
        # "no_anim on, match:namespace wallpaper"
      ];

      decoration = {
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        fullscreen_opacity = 1.0;
        rounding = 7;

        blur = {
          enabled = true;
          size = 4;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
          popups = true;
        };

        shadow = {
          enabled = true;
          range = 12;
          offset = "3 3";
        };
      };

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

      # exec = [
      #   "hyprctl setcursor ${config.gtk.cursorTheme.name} ${toString config.gtk.cursorTheme.size}"
      # ];

      bindr =
        let
          osd = lib.getExe' pkgs.swayosd "swayosd-client";
        in
        [
          "CAPS,Caps_Lock,exec,${osd} --caps-lock"
        ];

      bind =
        let
          # wlogout = lib.getExe pkgs.wlogout;
          grimblast = lib.getExe pkgs.grimblast;
          osd = lib.getExe' pkgs.swayosd "swayosd-client";
          defaultApp = type: "${lib.getExe pkgs.handlr-regex} launch ${type}";
        in
        [
          # Power menu
          # ",XF86PowerOff,exec,${wlogout} --protocol layer-shell"
          # Lock
          "SUPER,l,exec,pidof hyprlock || hyprlock"
          # Hyprpicker
          "SUPERSHIFT,c,exec,hyprpicker -a"
          # Program bindings
          "SUPER,RETURN,exec,ghostty +new-window"
          "SUPER,e,exec,${defaultApp "text/plain"}"
          "SUPER,b,exec,${defaultApp "x-scheme-handler/https"}"
          "ALT_L,SPACE,exec,vicinae toggle"
          "SUPER,v,exec,vicinae vicinae://extensions/vicinae/clipboard/history?toggle=true"
          # Brightness control (only works if the system has lightd)
          ",XF86MonBrightnessUp,exec,${osd} --brightness raise"
          ",XF86MonBrightnessDown,exec,${osd} --brightness lower"
          # Volume
          ",XF86AudioRaiseVolume,exec,${osd} --output-volume raise"
          ",XF86AudioLowerVolume,exec,${osd} --output-volume lower"
          ",XF86AudioMute,exec,${osd} --output-volume mute-toggle"
          "SHIFT,XF86AudioRaiseVolume,exec,${osd} --output-volume raise"
          "SHIFT,XF86AudioLowerVolume,exec,${osd} --output-volume lower"
          "SHIFT,XF86AudioMute,exec,${osd} --output-volume mute-toggle"
          ",XF86AudioMicMute,exec,${osd} --input-volume mute-toggle"
          # Screenshotting
          ",Print,exec,${grimblast} --notify --freeze copy area"
          "SHIFT,Print,exec,${grimblast} --notify --freeze copy output"

          # Hyprexpo Plugin
          # "ALT_L,TAB,hyprexpo:expo,toggle"

          # Atalhos de teclado para perfis de energia
          "SUPER,F1,exec,powerprofilesctl set power-saver"
          "SUPER,F2,exec,powerprofilesctl set balanced"
          "SUPER,F3,exec,powerprofilesctl set performance"
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
