{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    ../common/optional/btrfs.nix
    # ../common/optional/encrypted-root.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ ];
    };
    kernelModules = ["kvm-amd"];
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      # size = 16*1024;
    }
  ];

  # nixpkgs.hostPlatform.system = "x86_64-linux";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # hardware.cpu.amd.updateMicrocode = true;
  # powerManagement.cpuFreqGovernor = "ondemand";
  # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
