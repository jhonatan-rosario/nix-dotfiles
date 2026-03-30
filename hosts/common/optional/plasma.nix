{
  pkgs,
  ...
}:
{
  services.xserver.enable = true;

  # Legacy Display Manager
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.displayManager.sddm.wayland.compositor = "kwin";
  # services.displayManager.defaultSession = "plasma";

  services.desktopManager.plasma6.enable = true;
  services.displayManager.plasma-login-manager = {
    enable = true;
  };
  programs.chromium.enablePlasmaBrowserIntegration = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      kdePackages.xdg-desktop-portal-kde
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
