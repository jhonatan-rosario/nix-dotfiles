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
    ./features/pass
    # ./features/backup
  ];
  # Red
  wallpaper = pkgs.wallpapers.aenami-dawn;
  colorScheme = nix-colors.colorSchemes.catppuccin-macchiato;
}
