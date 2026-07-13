{
  ...
}:
{
  wayland.windowManager.hyprland = {
    settings = {
      general = {
        gaps_in = 5;
        gaps_out = 10;
      };

      exec-once = [
        "noctalia"
      ];

      layerrule = [
        {
          name = "noctalia";
          "match:namespace" = "noctalia-background-.*$";
          "ignore_alpha" = 0.5;
          blur = true;
          "blur_popups" = true;
        }
      ];

      decoration = {
        rounding = 20;
        rounding_power = 2;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          vibrancy = 0.1696;
        };
      };

      bind =
        let
          noctalia = "noctalia msg";
        in
        [
          # Session Menu
          "ALT,F4,exec,${noctalia} panel-toggle session"

          # Lock
          "SUPER,l,exec,${noctalia} session lock"

          # Program bindings
          "ALT_L,SPACE,exec,${noctalia} panel-toggle launcher"
          "SUPER,v,exec,${noctalia} panel-toggle clipboard"

          # Window Switcher
          "ALT_L,TAB,exec,${noctalia} window-switcher"

          # Brightness control (only works if the system has lightd)
          ",XF86MonBrightnessUp,exec,${noctalia} brightness-up all 10"
          ",XF86MonBrightnessDown,exec,${noctalia} brightness-down all 10"

          # Volume
          ",XF86AudioRaiseVolume,exec,${noctalia} volume-up 10"
          ",XF86AudioLowerVolume,exec,${noctalia} volume-down 10"
          ",XF86AudioMute,exec,${noctalia} volume-mute"
          "SHIFT,XF86AudioRaiseVolume,exec,${noctalia} volume-up 20"
          "SHIFT,XF86AudioLowerVolume,exec,${noctalia} volume-down 20"
          ",XF86AudioMicMute,exec,${noctalia} mic-mute"

          # Atalhos de teclado para perfis de energia
          "SUPER,F1,exec,${noctalia} power-cycle"

          # Screen Recorder
          "SUPER,r,exec,${noctalia} plugin noctalia/screen_recorder:service all toggle"

          # Notes
          "SUPER,n,exec,${noctalia} panel-toggle noctalia/notes:panel"
        ];
    };
  };
}
