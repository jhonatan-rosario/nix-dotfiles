{pkgs, ...}: {
  imports = [
    ./alacritty.nix
    ./imv.nix
    ./cliphist.nix
    # ./mako.nix
    ./swaync.nix
    ./swayosd.nix
    ./waybar.nix
    ./anyrun.nix
    ./wlogout.nix
    # ./swayidle.nix
    # ./swaylock.nix
  ];

  xdg.mimeApps.enable = true;
  home.packages = with pkgs; [
    wf-recorder
    wl-clipboard
    kdePackages.qt6ct
    nwg-look
    networkmanagerapplet
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
  };

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-wlr];
}
