{
  config,
  pkgs,
  ...
}:
let
  # nix-colors-lib = nix-colors.lib.contrib { inherit pkgs; };
  # inherit (nix-colors-lib) gtkThemeFromScheme;
in
{
  gtk = {
    enable = true;
    colorScheme = "dark";
    font = {
      inherit (config.fontProfiles.regular) name size;
    };
    theme = {
      name = "Catppuccin-GTK-Dark";
      package = pkgs.magnetic-catppuccin-gtk; # materia-theme
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      package = pkgs.catppuccin-cursors.macchiatoDark; # pkgs.apple-cursor
      name = "catppuccin-macchiato-dark-cursors"; # macOS
      size = 24;
    };
    gtk4.theme = config.gtk.theme;
  };

  # home.file = {
  #   ".icons/Papirus".source = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
  # };

  services.xsettingsd = {
    enable = true;
    settings = {
      "Gtk/CursorThemeName" = "${config.gtk.cursorTheme.name}";
      "Net/ThemeName" = "${config.gtk.theme.name}";
      "Net/IconThemeName" = "${config.gtk.iconTheme.name}";
    };
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
