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
    ./qt.nix
    ./onlyoffice.nix
    ./brave.nix
    ./obsidian.nix
    ./zenbrowser.nix
    # ./vscode.nix
  ];

  home.packages = with pkgs; [
    libnotify
    anydesk
    remmina
    antigravity-nix
    jetbrains.datagrip
    galaxy-buds-client
    # winboat
    # zed-editor-fhs
    # bitwarden-desktop # Problema no build versão 2026.2.1
    # antigravity
    # dbeaver-bin
  ];

  home.persistence."/persist".directories = [
    "DataGripProjects"
    ".anydesk"
    ".gemini"
    ".antigravity"
    ".config/Antigravity"
    ".config/JetBrains"
    ".local/share/remmina"
    ".cache/remmina"
  ];

  # Also sets org.freedesktop.appearance color-scheme
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  # if config.colorscheme.mode == "dark"
  # then "prefer-dark"
  # else if config.colorscheme.mode == "light"
  # then "prefer-light"
  # else "default";

  # xdg.portal = {
  #   enable = true;
  #   config.common.default = "*";
  # };
}
