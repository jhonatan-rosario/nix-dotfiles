# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  pkgs,
  ...
}:
let
  nix-colors = inputs.nix-colors;
in
{
  imports = [
    nix-colors.homeManagerModules.default
    ./global
    ./features/programming
    ./features/desktop/hyprland
    ./features/desktop/niri # Em teste; comente esta linha para desligar
    # ./features/pass # Disabled in favor of GNOME Keyring
    # ./features/backup
  ];
  # Red
  wallpaper = pkgs.wallpapers.aenami-dawn;
  colorScheme = nix-colors.colorSchemes.catppuccin-macchiato;
}
