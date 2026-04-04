{ config, pkgs, ... }:

let
  colorScheme = config.colorScheme;
in
{

  xdg.mimeApps = {
    associations.added = {
      "x-scheme-handler/terminal" = "com.mitchellh.ghostty.desktop";
    };
    defaultApplications = {
      "x-scheme-handler/terminal" = "com.mitchellh.ghostty.desktop";
    };
  };

  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    systemd.enable = true;
    settings = {
      theme = "Catppuccin Mocha";
      font-family = "FiraCode Nerd Font";
      font-size = 12;
      window-decoration = false;
      cursor-style = "block";
      confirm-close-surface = false;
    };
    themes = {
      custom-theme = {
        background = "${colorScheme.palette.base00}";
        cursor-color = "${colorScheme.palette.base06}";
        foreground = "${colorScheme.palette.base07}";
        palette = [
          "0=${colorScheme.palette.base00}"
          "1=${colorScheme.palette.base01}"
          "2=${colorScheme.palette.base02}"
          "3=${colorScheme.palette.base03}"
          "4=${colorScheme.palette.base04}"
          "5=${colorScheme.palette.base05}"
          "6=${colorScheme.palette.base06}"
          "7=${colorScheme.palette.base07}"
          "8=${colorScheme.palette.base08}"
          "9=${colorScheme.palette.base09}"
          "10=${colorScheme.palette.base0A}"
          "11=${colorScheme.palette.base0B}"
          "12=${colorScheme.palette.base0C}"
          "13=${colorScheme.palette.base0D}"
          "14=${colorScheme.palette.base0E}"
          "15=${colorScheme.palette.base0F}"
        ];
        selection-background = "${colorScheme.palette.base02}";
        selection-foreground = "${colorScheme.palette.base07}";
      };
    };
  };
}
