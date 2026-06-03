{ ... }:
{
  programs.micro = {
    enable = true;
    settings = {
      softwrap = true;
      wordwrap = true;
    };
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
