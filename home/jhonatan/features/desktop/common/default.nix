{
  inputs,
  pkgs,
  config,
  ...
}:
let
  antigravity-nix = inputs.antigravity-nix.packages.x86_64-linux.default;
in
{
  imports = [
    ./font.nix
    ./flatpak.nix
    ./playerctl.nix
    ./gtk.nix
    # ./qt.nix
    # ./vscode.nix
    # ./brave.nix
  ];

  home.packages = with pkgs; [
    libnotify
    anydesk
    remmina
    antigravity-nix
    jetbrains.datagrip
    # antigravity
    # dbeaver-bin
    # bitwarden-desktop
  ];

  # Also sets org.freedesktop.appearance color-scheme
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  # if config.colorscheme.mode == "dark"
  # then "prefer-dark"
  # else if config.colorscheme.mode == "light"
  # then "prefer-light"
  # else "default";

  xdg.portal.enable = true;
}
