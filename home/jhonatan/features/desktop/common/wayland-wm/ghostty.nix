{ ... }:

{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      font-family = "FiraCode Nerd Font";
      font-size = 12;
      window-decoration = false;
      cursor-style = "block";
    };
  };
}
