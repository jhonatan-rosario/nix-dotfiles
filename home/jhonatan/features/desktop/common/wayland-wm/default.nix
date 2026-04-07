{ pkgs, ... }:
{
  imports = [
    ./imv.nix
    ./cliphist.nix
    ./zathura.nix
    ./udiskie.nix
    ./noctalia.nix
    # ./wlogout.nix
    # ./swayosd.nix
    # ./swaync.nix
    # ./vicinae.nix
    # ./waybar.nix
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
    qimgv # Image viewer
    mpv # Video player
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
}
