{
  config,
  pkgs,
  nix-colors,
  ...
}: 
let
  nix-colors-lib = nix-colors.lib.contrib { inherit pkgs; };
  inherit (nix-colors-lib) gtkThemeFromScheme;
in {
  gtk = {
    enable = true;
    font = {
      inherit (config.fontProfiles.regular) name size;
    };
    theme = {
      name = config.colorscheme.slug;
      package = gtkThemeFromScheme {
        scheme = config.colorscheme;
      }; # materia-theme
    };
    # theme = {
    #   name = "Catppuccin-GTK-Dark";
    #   package = pkgs.magnetic-catppuccin-gtk; # materia-theme
    # };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      package = pkgs.catppuccin-cursors.macchiatoDark; # pkgs.apple-cursor
      name = "catppuccin-macchiato-dark-cursors"; #macOS
      size = 24;
    };
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

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
}
