{...}: {
  # Enable networking
  networking.networkmanager = {
    enable = true;
    # unmanaged = [ "wlp0s20f3" ];
  }; # Easiest to use and most distros use this by default.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
