{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    ../common/optional/ephemeral-btrfs.nix
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
    kernelModules = [ "kvm-amd" ];
  };

  disko.devices.disk.main = {
    device = "/dev/nvme0n1";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          size = "1M";
          type = "EF02";
        };
        esp = {
          name = "ESP";
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        luks = {
          size = "100%";
          content = {
            name = "root";
            type = "luks";
            settings.allowDiscards = true;
            content = {
              type = "btrfs";
              postCreateHook = ''
                MNTPOINT=$(mktemp -d)
                mount -t btrfs "$device" "$MNTPOINT"
                trap 'umount $MNTPOINT; rm -d $MNTPOINT' EXIT
                btrfs subvolume snapshot -r $MNTPOINT/root $MNTPOINT/root-blank
              '';
              subvolumes = {
                "/root" = {
                  mountOptions = [ "compress=zstd" ];
                  mountpoint = "/";
                };
                "/nix" = {
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                  mountpoint = "/nix";
                };
                "/persist" = {
                  mountOptions = [ "compress=zstd" ];
                  mountpoint = "/persist";
                };
                "/swap" = {
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                  mountpoint = "/swap";
                  swap.swapfile = {
                    size = "8196M";
                    path = "swapfile";
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  # nixpkgs.hostPlatform.system = "x86_64-linux";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # hardware.cpu.amd.updateMicrocode = true;
  # powerManagement.cpuFreqGovernor = "ondemand";
  # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
