{ ... }:
{
  # Enable networking
  networking.networkmanager = {
    enable = true;
    # unmanaged = [ "wlp0s20f3" ];
  }; # Easiest to use and most distros use this by default.

}
