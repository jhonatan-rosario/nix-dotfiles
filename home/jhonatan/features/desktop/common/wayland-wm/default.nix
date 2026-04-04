{ pkgs, ... }:
{
  imports = [
    ./imv.nix
    ./cliphist.nix
    ./swaync.nix
    ./swayosd.nix
    ./wlogout.nix
    ./zathura.nix
    ./vicinae.nix
    ./udiskie.nix
    ./waybar.nix
    ./yazi.nix
    ./ghostty.nix
    # ./ashell.nix
  ];

  xdg.mimeApps.enable = true;
  home.packages = with pkgs; [
    wf-recorder
    wl-clipboard
    kdePackages.qt6ct
    nwg-look
    networkmanagerapplet
    qimgv # Image viewer
    mpv # Video player
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
}
