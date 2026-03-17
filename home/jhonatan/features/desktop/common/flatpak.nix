{
  services.flatpak = {
    enable = true;
    packages = [
      # "com.anydesk.Anydesk"
      # "com.bitwarden.desktop"
      "io.github.zen_browser.zen"
    ];
  };

  # Set as default browser
  xdg.mimeApps = {
    associations.added = {
      "text/html" = "app.zen_browser.zen.desktop.desktop";
      "x-scheme-handler/http" = "app.zen_browser.zen.desktop.desktop";
      "x-scheme-handler/https" = "app.zen_browser.zen.desktop.desktop";
      "x-scheme-handler/about" = "app.zen_browser.zen.desktop.desktop";
    };
    defaultApplications = {
      "text/html" = "app.zen_browser.zen.desktop.desktop";
      "x-scheme-handler/http" = "app.zen_browser.zen.desktop.desktop";
      "x-scheme-handler/https" = "app.zen_browser.zen.desktop.desktop";
      "x-scheme-handler/about" = "app.zen_browser.zen.desktop.desktop";
    };
  };
}
