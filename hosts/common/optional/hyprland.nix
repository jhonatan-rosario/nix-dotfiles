{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  programs.hyprland = {
    enable = true;
    # withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };

  environment.systemPackages = with pkgs; [
    kitty # required for the default Hyprland config
    hyprshutdown
    pkgs.magnetic-catppuccin-gtk
    gnome-themes-extra # Optional: for extra GTK theme support
  ];

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  programs.noctalia-greeter = {
    enable = true;

    # Optional configuration
    greeter-args = "";
    settings = {
      session.default = "Hyprland";

      appearance.schema = "Catppuccin";

      output.name = "eDP-1";

      cursor = {
        theme = "Catppuccin-GTK-Dark";
        size = 24;
        path = "${pkgs.catppuccin-cursors.macchiatoDark}/share/icons";
      };

      keyboard = {
        layout = "us";
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };
}
