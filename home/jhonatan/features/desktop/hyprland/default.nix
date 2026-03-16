{
  lib,
  config,
  pkgs,
  outputs,
  inputs,
  ...
}: let
  getHostname = x: lib.last (lib.splitString "@" x);
  # remoteColorschemes =
  #   lib.mapAttrs' (n: v: {
  #     name = getHostname n;
  #     value = v.config.colorscheme.rawColorscheme.colors.${config.colorscheme.mode};
  #   })
  #   outputs.homeConfigurations;
  inherit (config.colorscheme) palette;
  rgb = color: "rgb(${lib.removePrefix "#" color})";
  rgba = color: alpha: "rgba(${lib.removePrefix "#" color}${alpha})";
in {
  imports = [
    ../common
    ../common/wayland-wm

    ./basic-binds.nix
    ./hyprbars.nix
    ./hyprexpo.nix
    ./hyprpaper.nix
    ./hyprlock.nix
    ./hypridle.nix
  ];

  xdg.portal = {
    extraPortals = [pkgs.xdg-desktop-portal-wlr];
    config.hyprland = {
      default = ["wlr" "gtk"];
    };
  };

  home.packages = with pkgs; [
    grimblast
    hyprpicker
    easyeffects
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      # Same as default, but stop graphical-session too
      extraCommands = lib.mkBefore [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };

    settings = {
      general = {
        # misterio
        # gaps_in = 15;
        # gaps_out = 20;
        # border_size = 2;
        "col.active_border" = rgb palette.base07;
        "col.inactive_border" = rgb palette.base04;
        # allow_tearing = true;

        gaps_in = 3;
        gaps_out = 4;
        border_size = 3;
        # "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        # "col.inactive_border" = "rgba(595959aa)";
        allow_tearing = true;
        layout = "dwindle";
        resize_on_border = true;
      };

      exec-once = [
        "hyprpaper"
        "swayosd-server"
        "wl-paste --type text --watch cliphist store" # Stores only text data
      ];

      monitor = [
        "eDP-1, 1920x1080@120, 0x0, 1"
        "HDMI-A-1, highres@highrr, auto-right, 1"        
      ];

      cursor.inactive_timeout = 4;
      group = {
        "col.border_active" = rgb palette.base07;
        "col.border_inactive" = rgb palette.base04;
        "col.border_locked_active" = rgb palette.base09;
        "col.border_locked_inactive" = rgb palette.base04;
        groupbar.font_size = 11;

        groupbar = {
          height = 4;
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
        pseudotile = true;
      };

      misc = {
        vfr = true;
        close_special_on_empty = true;
        focus_on_activate = true;
        key_press_enables_dpms = true;
        # Unfullscreen when opening something
        new_window_takes_over_fullscreen = 2;
      };

      windowrulev2 = let
        # sweethome3d-tooltips = "title:^(win[0-9])$,class:^(com-eteks-sweethome3d-SweetHome3DBootstrap)$";
        xembedsniproxy = "class:^()$,title:^()$,xwayland:1,floating:1";
        # steam = "title:^()$,class:^(steam)$";
        # steamGame = "class:^(steam_app_[0-9]*)$";
        # kdeconnect-pointer = "class:^(org.kdeconnect.daemon)$";
        anydesk = "class:^(Anydesk)$,title:^(anydesk)$";
      in [
        "float, ${anydesk}"
        # "nofocus, ${sweethome3d-tooltips}"

        "noblur, ${xembedsniproxy}"
        # "opacity 0, ${xembedsniproxy}"
        # "noinitialfocus, ${xembedsniproxy}"
        # "workspace special, ${xembedsniproxy}"
      ];
      # ++ (lib.mapAttrsToList (name: colors:
      #   "bordercolor ${rgba colors.primary "aa"} ${rgba colors.primary_container "aa"}, title:^(\\[${name}\\])"
      # ) remoteColorschemes);
      layerrule = [
        "animation fade,hyprpicker"
        "animation fade,selection"

        "animation fade,waybar"
        "blur,waybar"
        "ignorezero,waybar"

        "blur,notifications"
        "ignorezero,notifications"

        # "blur,wofi"
        # "ignorezero,wofi"

        # "noanim,wallpaper"
      ];

      decoration = {
        active_opacity = 1.0;
        inactive_opacity = 0.85;
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

        #artazol
        # blur {
        #   enabled = true
        #   size = 20
        #   passes = 3
        #   new_optimizations=true
        # }

        shadow = {
          enabled = true;
          range = 12;
          offset = "3 3";
        };

        # drop_shadow = true;
        # shadow_range = 12;
        # shadow_offset = "3 3";
        # "col.shadow" = "0x44000000";
        # "col.shadow_inactive" = "0x66000000";
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

      exec = [
        "hyprctl setcursor ${config.gtk.cursorTheme.name} ${toString config.gtk.cursorTheme.size}"
      ];

      bindr = let
        osd = lib.getExe' pkgs.swayosd "swayosd-client";
      in [
        "CAPS,Caps_Lock,exec,${osd} --caps-lock"
      ];

      bind = let
        wlogout = lib.getExe pkgs.wlogout;
        grimblast = lib.getExe pkgs.grimblast;
        osd = lib.getExe' pkgs.swayosd "swayosd-client";
        defaultApp = type: "${lib.getExe pkgs.handlr-regex} launch ${type}";
      in [
        # Power menu
        ",XF86PowerOff,exec,${wlogout} --protocol layer-shell"
        # Lock
        "SUPER,ESCAPE,exec,pidof hyprlock || hyprlock"
        # Hyprpicker
        "SUPERSHIFT,c,exec,hyprpicker -a"
        # Program bindings
        "SUPER,RETURN,exec,${defaultApp "x-scheme-handler/terminal"}"
        "SUPER,e,exec,${defaultApp "text/plain"}"
        "SUPER,b,exec,${defaultApp "x-scheme-handler/https"}"
        "ALT_L,SPACE,exec,pkill anyrun || anyrun"
        "SUPER,v,exec,pkill anyrun || cliphist list | anyrun --show-results-immediately true --plugins ${inputs.anyrun.packages.${pkgs.system}.stdin}/lib/libstdin.so | cliphist decode | wl-copy"
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
        "ALT_L,TAB,hyprexpo:expo,toggle"
      ];
      #   ++ (
      #     let
      #       playerctl = lib.getExe' config.services.playerctld.package "playerctl";
      #       playerctld = lib.getExe' config.services.playerctld.package "playerctld";
      #     in
      #       lib.optionals config.services.playerctld.enable [
      #         # Media control
      #         ",XF86AudioNext,exec,${playerctl} next"
      #         ",XF86AudioPrev,exec,${playerctl} previous"
      #         ",XF86AudioPlay,exec,${playerctl} play-pause"
      #         ",XF86AudioStop,exec,${playerctl} stop"
      #         "SHIFT,XF86AudioNext,exec,${playerctld} shift"
      #         "SHIFT,XF86AudioPrev,exec,${playerctld} unshift"
      #         "SHIFT,XF86AudioPlay,exec,systemctl --user restart playerctld"
      #       ]
      #   )
      #   ++
      #   # Screen lock
      #   (
      #     let
      #       swaylock = lib.getExe config.programs.swaylock.package;
      #     in
      #       lib.optionals config.programs.swaylock.enable [
      #         "SUPER,backspace,exec,${swaylock} -S --grace 2 --grace-no-mouse"
      #         "SUPER,XF86Calculator,exec,${swaylock} -S --grace 2 --grace-no-mouse"
      #       ]
      #   )
      # ++
      # Notification manager
      # (
      #   let
      #     makoctl = lib.getExe' config.services.mako.package "makoctl";
      #   in
      #     lib.optionals config.services.mako.enable [
      #       "SUPER,w,exec,${makoctl} dismiss"
      #       "SUPERSHIFT,w,exec,${makoctl} restore"
      #     ]
      # );
      #   ++
      #   # Launcher
      #   (
      #     let
      #       wofi = lib.getExe config.programs.wofi.package;
      #     in
      #       lib.optionals config.programs.wofi.enable [
      #         "SUPER,x,exec,${wofi} -S drun -x 10 -y 10 -W 25% -H 60%"
      #         "SUPER,s,exec,specialisation $(specialisation | ${wofi} -S dmenu)"
      #         "SUPER,d,exec,${wofi} -S run"

      #         "SUPERALT,x,exec,${remote} ${wofi} -S drun -x 10 -y 10 -W 25% -H 60%"
      #         "SUPERALT,d,exec,${remote} ${wofi} -S run"
      #       ]
      #       ++ (
      #         let
      #           pass-wofi = lib.getExe (pkgs.pass-wofi.override {pass = config.programs.password-store.package;});
      #         in
      #           lib.optionals config.programs.password-store.enable [
      #             ",XF86Calculator,exec,${pass-wofi}"
      #             "SHIFT,XF86Calculator,exec,${pass-wofi} fill"

      #             "SUPER,semicolon,exec,${pass-wofi}"
      #             "SHIFTSUPER,semicolon,exec,${pass-wofi} fill"
      #           ]
      #       ) ++ (
      #         let
      #           cliphist = lib.getExe config.services.cliphist.package;
      #         in
      #         lib.optionals config.services.cliphist.enable [
      #           ''SUPER,c,exec,selected=$(${cliphist} list | ${wofi} -S dmenu) && echo "$selected" | ${cliphist} decode | wl-copy''
      #         ]
      #       )
      #   );

      # monitor = let
      #   waybarSpace = let
      #     inherit (config.wayland.windowManager.hyprland.settings.general) gaps_in gaps_out;
      #     inherit (config.programs.waybar.settings.primary) position height width;
      #     gap = gaps_out - gaps_in;
      #   in {
      #     top = if (position == "top") then height + gap else 0;
      #     bottom = if (position == "bottom") then height + gap else 0;
      #     left = if (position == "left") then width + gap else 0;
      #     right = if (position == "right") then width + gap else 0;
      #   };
      # in
      #   [
      #     ",addreserved,${toString waybarSpace.top},${toString waybarSpace.bottom},${toString waybarSpace.left},${toString waybarSpace.right}"
      #   ]
      #   ++ (map (
      #     m: "${m.name},${
      #       if m.enabled
      #       then "${toString m.width}x${toString m.height}@${toString m.refreshRate},${m.position},1"
      #       else "disable"
      #     }"
      #   ) (config.monitors));

      # workspace = map (m: "name:${m.workspace},monitor:${m.name}") (
      #   lib.filter (m: m.enabled && m.workspace != null) config.monitors
      # );
    };
    # This is order sensitive, so it has to come here.
    extraConfig = ''
      # Passthrough mode (e.g. for VNC)
      bind=SUPER,P,submap,passthrough
      submap=passthrough
      bind=SUPER,P,submap,reset
      submap=reset
    '';
  };
}
