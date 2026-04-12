{ inputs, ... }:
{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  services.flatpak = {
    enable = true;
    packages = [
      "com.bitwarden.desktop"
    ];
  };

  home.persistence."/persist".directories = [
    ".local/share/flatpak"
    ".var/app/com.bitwarden.desktop"
  ];

  # Set as default browser
  xdg.mimeApps = {
    associations.added = {
      "application/pdf" = "org.pwmt.zathura.desktop";
    };
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
    };
  };
}
