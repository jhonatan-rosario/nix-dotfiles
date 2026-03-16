{config, ...}: let
  hostname = config.networking.hostName;
in {
  boot.initrd.luks.devices = {
    ${hostname} = {
      # device = "/dev/disk/by-uuid/caf47831-0ec0-49db-9ce4-f847ff70c316";
      device = "/dev/disk/by-label/${hostname}_crypt";
      allowDiscards = true;
      keyFileTimeout = 5;
      keyFileSize = 4096;
      # pinning to /dev/disk/by-id/usbkey works
      keyFile = "/dev/disk/by-id/usb-Generic-_SD_MMC_MS_PRO_20121112761000000-0:0-part1";
    };
  };
  # luks.devices."${hostname}".device = "/dev/disk/by-label/fedora";
}
