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
    libsecret # Optional: for storing passwords in the GNOME keyring
  ];

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

  services.gnome.gnome-keyring.enable = true;

  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    # greetd-password.enableGnomeKeyring = true;
    # login.enableGnomeKeyring = true;
  };

  programs.seahorse.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };
}
