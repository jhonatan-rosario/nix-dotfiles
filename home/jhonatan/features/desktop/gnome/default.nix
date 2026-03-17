{ pkgs, ... }:
{
  imports = [ ../common ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
    config = {
      common = {
        default = [
          "gnome"
        ];
      };
    };
  };
}
