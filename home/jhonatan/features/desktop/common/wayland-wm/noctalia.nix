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

  # home.persistence = {
  #   "/persist".directories = [
  #     ".cache/noctalia"
  #     ".cache/noctalia-qs"
  #     ".config/noctalia/plugins"
  #   ];
  # };

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
        ];

      };

      shell = {
        screen_corners.enabled = true;
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
      };

    };
  };
}
