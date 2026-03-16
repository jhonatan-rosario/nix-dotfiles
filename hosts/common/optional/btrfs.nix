# This file contains an ephemeral btrfs root configuration
# TODO: perhaps partition using disko in the future
{
  lib,
  config,
  ...
}: let
  hostname = config.networking.hostName;
in {
  boot.initrd = {
    supportedFilesystems = ["btrfs"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=root"
        "compress=zstd"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "noatime"
        "compress=zstd"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "noatime"
        "compress=zstd"
      ];
    };

    "/snapshots" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=snapshots"
        "noatime"
        "compress=zstd"
      ];
    };

    "/swap" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=swap"
        "noatime"
      ];
    };
  };
}
