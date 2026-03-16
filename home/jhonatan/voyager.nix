# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  nix-colors,
  ...
}:
{
  imports = [
    nix-colors.homeManagerModules.default
    ./global
    ./features/programming
    # ./features/desktop/hyprland
    ./features/desktop/plasma
    ./features/work
  ];
  # Red
  wallpaper = pkgs.wallpapers.aenami-dawn;

  colorScheme = nix-colors.colorSchemes.catppuccin-macchiato;

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      workspace = "1";
      primary = true;
    }
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      workspace = "2";
      primary = false;
    }
  ];
}
