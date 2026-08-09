{ pkgs, ... }:
{
  home.packages = [ pkgs.kanshi ];

  services.kanshi = {
    enable = true;

    settings = [
      {
        profile = {
          name = "laptop_only";
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              position = "0,0";
              scale = 1.0;
            }
          ];
        };
      }

      {
        profile = {
          name = "home";
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              position = "0,0";
              scale = 1.0;
            }
            {
              criteria = "HDMI-A-1";
              status = "enable";
              position = "1920,0";
              scale = 1.0;
            }
          ];
        };
      }

      {
        profile = {
          name = "work";
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              position = "0,0";
              scale = 1.0;
            }
            {
              criteria = "DP-1";
              status = "enable";
              position = "1920,0";
              scale = 1.0;
            }
            {
              criteria = "HDMI-A-1";
              status = "enable";
              position = "3840,0";
              scale = 1.0;
            }
          ];
        };
      }
    ];
  };
}
