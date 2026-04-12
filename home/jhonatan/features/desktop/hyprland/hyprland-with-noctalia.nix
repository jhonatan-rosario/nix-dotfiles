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
  wayland.windowManager.hyprland = {
    settings = {
      general = {
        gaps_in = 5;
        gaps_out = 10;
      };

      exec-once = [
        "noctalia-shell"
      ];

      dwindle = {
        split_width_multiplier = 1.35;
        pseudotile = true;
      };

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
          noctalia = "noctalia-shell ipc call";
        in
        [
          # Lock
          "SUPER,l,exec,${noctalia} lockScreen lock"

          # Program bindings
          "ALT_L,SPACE,exec,${noctalia} launcher toggle"
          "SUPER,v,exec,${noctalia} launcher clipboard"

          # Brightness control (only works if the system has lightd)
          ",XF86MonBrightnessUp,exec,${noctalia} brightness increase"
          ",XF86MonBrightnessDown,exec,${noctalia} brightness decrease"

          # Volume
          ",XF86AudioRaiseVolume,exec,${noctalia} volume increase"
          ",XF86AudioLowerVolume,exec,${noctalia} volume decrease"
          ",XF86AudioMute,exec,${noctalia} volume muteOutput"
          "SHIFT,XF86AudioRaiseVolume,exec,${noctalia} volume increase"
          "SHIFT,XF86AudioLowerVolume,exec,${noctalia} volume decrease"
          "SHIFT,XF86AudioMute,exec,${noctalia} volume muteOutput"
          ",XF86AudioMicMute,exec,${noctalia} volume muteInput"

          # Atalhos de teclado para perfis de energia
          "SUPER,F1,exec,${noctalia} powerProfile set powersaver && ${noctalia} powerProfile enableNoctaliaPerformance"
          "SUPER,F2,exec,${noctalia} powerProfile set balanced && ${noctalia} powerProfile disableNoctaliaPerformance"
          "SUPER,F3,exec,${noctalia} powerProfile set performance && ${noctalia} powerProfile disableNoctaliaPerformance"
        ];
    };
  };
}
