{config, ...}: {
  # Set as default terminal
  xdg.mimeApps = {
    associations.added = {
      "x-scheme-handler/terminal" = "Alacritty.desktop";
    };
    defaultApplications = {
      "x-scheme-handler/terminal" = "Alacritty.desktop";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = let
      inherit (config.colorscheme) palette;
      colorsWithHashtag = builtins.mapAttrs (name: value: "#${value}") palette;
    in {
      font = {
        size = 14;
        normal = {
          family = "FiraCode Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "FiraCode Nerd Font Mono";
          style = "Bold";
        };
      };
      window = {
        padding = {
          x = 24;
          y = 26;
        };
      };

      cursor = {
        style = {
          shape = "Beam";
        };
      };
      colors = with colorsWithHashtag; rec {
        primary = {
          foreground = base05;
          background = base00;
          bright_foreground = base07;
        };
        selection = {
          text = base05;
          background = base02;
        };
        cursor = {
          text = base00;
          cursor = base05;
        };
        normal = {
          black = base00;
          white = base05;
          red = base08;
          green = base0B;
          yellow = base0A;
          blue = base0D;
          magenta = base0E;
          cyan = base07;
        };
        bright = {
          black = base04;
        };
      };
    };
  };
}
