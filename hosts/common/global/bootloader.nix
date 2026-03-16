{
  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "max";
      efi.canTouchEfiVariables = true;
      # grub = {
      #   enable = true;
      #   device = "nodev";
      #   efiSupport = true;
      #   useOSProber = true;
      # };
    };
    initrd = {
      enable = true;
      systemd.enable = true;
    };
  };
}
