{
  programs.imv.enable = true;

  xdg.mimeApps = {
    associations.added = {
      "image/jpeg" = "imv.desktop";
      "image/jpg" = "imv.desktop";
      "image/png" = "imv.desktop";
      "image/svg" = "imv.desktop";
    };
    defaultApplications = {
      "image/jpeg" = "imv.desktop";
      "image/jpg" = "imv.desktop";
      "image/png" = "imv.desktop";
      "image/svg" = "imv.desktop";
    };
  };
}
