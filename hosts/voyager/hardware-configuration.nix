{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    ../common/optional/btrfs.nix
    ../common/optional/encrypted-root.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "vmd"
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "ums_realtek"
        "sd_mod"
      ];
      kernelModules = ["usb_storage" "rtsx_pci_sdmmc"];
    };
    kernelModules = ["kvm-intel"];
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
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
