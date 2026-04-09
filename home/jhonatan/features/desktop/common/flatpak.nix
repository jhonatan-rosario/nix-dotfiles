{ inputs, ... }:
{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  services.flatpak = {
    enable = true;
    packages = [
      # "com.anydesk.Anydesk"
      "com.bitwarden.desktop"
      "io.github.zen_browser.zen"
      "com.devolutions.remotedesktopmanager"
    ];
  };

  home.persistence."/persist".directories = [
    ".local/share/flatpak"
    ".var/app/com.bitwarden.desktop"
    ".var/app/io.github.zen_browser.zen"
  ];

  # Set as default browser
  xdg.mimeApps = {
    associations.added = {
      "text/html" = "app.zen_browser.zen.desktop";
      "x-scheme-handler/http" = "app.zen_browser.zen.desktop";
      "x-scheme-handler/https" = "app.zen_browser.zen.desktop";
      "x-scheme-handler/about" = "app.zen_browser.zen.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";
    };
    defaultApplications = {
      "text/html" = "app.zen_browser.zen.desktop";
      "x-scheme-handler/http" = "app.zen_browser.zen.desktop";
      "x-scheme-handler/https" = "app.zen_browser.zen.desktop";
      "x-scheme-handler/about" = "app.zen_browser.zen.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";
    };
  };
}
