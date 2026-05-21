{ ... }:
{
  programs.micro = {
    enable = true;
  };

  home.sessionVariables = {
    EDITOR = "micro";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = [ "micro.desktop" ];
    };
  };
}
