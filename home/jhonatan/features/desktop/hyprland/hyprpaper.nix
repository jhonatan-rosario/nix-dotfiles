{
  config,
  ...
}:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [ "/home/jhonatan/nix/home/jhonatan/features/desktop/hyprland/city-horizon.jpg" ];
      # preload = [config.wallpaper];

      wallpaper = [
        ",/home/jhonatan/nix/home/jhonatan/features/desktop/hyprland/city-horizon.jpg"
        # ",${config.wallpaper}"
      ];
    };
  };
}
