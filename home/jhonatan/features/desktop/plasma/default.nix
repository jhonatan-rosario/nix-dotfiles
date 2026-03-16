{pkgs, ...}: {
  imports = [../common];

  programs.plasma = {
    enable = true;

    hotkeys.commands = {
      "launch-settings" = {
        name = "Launch Settings";
        key = "Meta+I";
        command = "plasma-open-settings";
      };
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-kde
    ];
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
    };
  };
}
