{
  pkgs,
  ...
}:
{
  # Set as default editor
  xdg.mimeApps = {
    associations.added = {
      "text/plain" = "code.desktop";
    };
    defaultApplications = {
      "text/plain" = "code.desktop";
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.antigravity;
  };

  home.persistence."/persist".directories = [
    ".config/Code"
    # ".config/VSCodium"
    # ".config/antigravity"
  ];
}
