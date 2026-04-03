{ ... }:
{
  # PDF Reader
  programs.vicinae = {
    enable = true;
    systemd.enable = true;
    settings = {
      close_on_focus_loss = false;
      theme = {
        dark = {
          name = "catppuccin-mocha";
        };
      };
    };
  };
}
