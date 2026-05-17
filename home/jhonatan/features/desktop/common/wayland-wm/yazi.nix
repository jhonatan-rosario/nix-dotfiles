{ pkgs, ... }:
let
  noctalia = "noctalia-shell ipc call";
in
{
  home.packages = with pkgs; [
    dragon-drop
  ];

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "yy";
    settings = {
      opener = {
        set-wallpaper = [
          {
            run = "${noctalia} wallpaper set %s1";
            for = "linux";
            desc = "Set as wallpaper";
          }
        ];
      };
      open = {
        prepend_rules = [
          {
            mime = "image/*";
            use = [
              "set-wallpaper"
              "open"
            ];
          }
        ];
      };
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = "!";
          for = "unix";
          run = "shell \"$SHELL\" --block";
          desc = "Open $SHELL here";
        }
        {
          on = "<Enter>";
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = "p";
          run = "plugin smart-paste";
          desc = "Paste into the hovered directory or CWD";
        }
        {
          on = "<C-n>";
          run = "shell -- dragon-drop -x -i -T %s1";
          desc = "Dragon Drop";
        }
        {
          on = "y";
          run = [
            "shell -- for path in %s; do echo file://$path; done | wl-copy -t text/uri-list"
            "yank"
          ];
        }
      ];
    };
    plugins = with pkgs.yaziPlugins; {
      inherit smart-enter;
      inherit smart-paste;
    };
  };

  xdg.portal = {
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-termfilechooser
    ];

    config.common."org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
  };

  xdg.configFile."xdg-desktop-portal-termfilechooser/config" = {
    enable = true;
    text = ''
      [filechooser]
      cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
      default_dir=$HOME
      env=TERMCMD=ghostty +new-window --title "Terminal FileChooser"
      open_mode=suggested
      save_mode=last
    '';
  };
}
