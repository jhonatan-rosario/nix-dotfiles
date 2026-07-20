{
  inputs,
  ...
}:
let
  noctaliaPkg = inputs.noctalia.outPath;
  nixosIcon = "${noctaliaPkg}/assets/images/distros/nixos.svg";
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.persistence = {
    "/persist".directories = [
      ".local/state/noctalia"
    ];
  };

  programs.noctalia = {
    enable = true;
    settings = {
      settingsVersion = 1;

      plugins = {
        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/official-plugins";
          }
          {
            enabled = true;
            name = "Community Noctalia Plugins";
            url = "https://github.com/noctalia-dev/community-plugins";
          }
        ];

        enabled = [
          "noctalia/screen_recorder"
          "noctalia/translator"
          "noctalia/notes"
          "noctalia/wallhaven"
          "cleboost/zed-provider"
        ];

      };

      shell = {
        polkit_agent = true;
        screen_corners.enabled = true;

        greeter_sync = {
          auto_sync = true;
        };
      };

      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        directory = "/home/jhonatan/nix/wallpapers";
        directory_dark = "/home/jhonatan/nix/wallpapers";
        directory_light = "/home/jhonatan/nix/wallpapers";
        default.path = "/home/jhonatan/nix/wallpapers/wallhaven_w5lpm6.png";
      };

      osd.kinds = {
        media = false;
      };

      battery = {
        warning_threshold = 30;
      };

      dock = {
        enabled = true;
        auto_hide = true;
        reserve_space = false;
      };

      location = {
        auto_locate = true;
      };

      bar.default = {
        border = "on_surface";
        border_width = 1.5;
        margin_edge = 6;
        margin_ends = 10;
        concave_edge_corners = false;
        panel_overlap = 2;

        start = [
          "launcher"
          "workspaces"
          "active_window"
          "media"
        ];

        center = [
          "date"
          "clock"
          "weather"
          "notifications"
        ];

        end = [
          "tray"
          "keyboard_layout"
          "temp"
          "cpu"
          "ram"
          "network"
          "bluetooth"
          "volume"
          "brightness"
          "battery"
          "session"
        ];
      };

      widget = {
        clock = {
          anchor = true;
          timezone = "America/Sao_Paulo";
          tooltip_format = "%A %D - %H:%M";
        };

        date = {
          timezone = "America/Sao_Paulo";
        };

        launcher = {
          custom_image = nixosIcon;
          custom_image_colorize = true;
        };

        media = {
          hide_when_no_media = true;
        };

        network = {
          show_label = false;
        };

        tray = {
          drawer = true;
        };

        weather = {
          show_condition = false;
        };

        bluetooth = {
          hide_when_no_connected_device = true;
        };

        keyboard_layout = {
          hide_when_single_layout = true;
          custom_labels = {
            "English (US, intl., with dead keys)" = "US (Intl)";
            "English (intl., with AltGr dead keys)" = "US (AltGr)";
            "Portuguese (Brazil)" = "PT (BR)";
          };
        };
      };

      lockscreen_widgets = {
        enabled = true;
        schema_version = 2;
        widget_order = [
          "lockscreen-widget-0000000000000001"
          "lockscreen-widget-0000000000000002"
        ];

        widgets = {
          widget.lockscreen-widget-0000000000000001 = {
            box_height = 128.0;
            box_width = 416.0;
            cx = 968.0;
            cy = 124.0;
            rotation = 0.0;
            type = "clock";

            settings = {
              background = false;
              center_text = true;
              clock_style = "digital";
            };
          };

          widget.lockscreen-widget-0000000000000002 = {
            box_height = 64.0;
            box_width = 192.0;
            cx = 966.0;
            cy = 196.0;
            rotation = 0.0;
            type = "weather";

            settings = {
              background = false;
              show_forecast = false;
            };
          };
        };
      };

    };
  };
}
