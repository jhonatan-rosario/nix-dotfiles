{
  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "max";
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      enable = true;
      systemd.enable = true;
    };
  };
}
