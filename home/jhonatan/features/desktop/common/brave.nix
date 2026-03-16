{
  pkgs,
  config, 
  ...
}:
{
  # Set as default browser
  xdg.mimeApps = {
    associations.added = {
      "text/html" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/about" = "brave-browser.desktop";
    };
    defaultApplications = {
      "text/html" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/about" = "brave-browser.desktop";
    };
  };

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = let
      inherit (config.gtk.theme) name package;
    in [
      # {
      #   id = "aaaaaaaaaabbbbbbbbbbccccccccccdd";
      #   crxPath = "${package}/share/themes/${name}/chrome/chrome-theme.crx";
      #   version = "1.0";
      # }
      { id = "cmpdlhmnmjhihmcfnigoememnffkimlk"; } # Catppuccin Chrome Theme - Macchiato
      { id = "lnjaiaapbakfhlbjenjkhffcdpoompki"; } # Catppuccin for GitHub File Explorer Icons
    ];
  };
}
