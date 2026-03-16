{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/jhonatan

    ../common/optional/gnome.nix # Desktop Environment
    # ../common/optional/plasma.nix # Desktop Environment
    # ../common/optional/hyprland.nix # Window Manager

    ../common/optional/disable-nvidia.nix
    ../common/optional/encrypted-root.nix
    ../common/optional/pipewire.nix
    ../common/optional/podman.nix
    ../common/optional/docker.nix
    ../common/optional/printing.nix
    ../common/optional/quietboot.nix
    ../common/optional/fingerprint.nix
    ../common/optional/bluetooth.nix
    ../common/optional/virtual-machine.nix
    ../common/optional/samba.nix
    ../common/optional/flatpak.nix
    ../common/optional/default-packages.nix
  ];

  networking = {
    hostName = "voyager";
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "i686-linux"
    ];
  };

  powerManagement.powertop.enable = true;
  programs = {
    light.enable = true;
    adb.enable = true;
    dconf.enable = true;
    git.enable = true;
  };

  # Lid settings
  services.logind = {
    # lidSwitch = "suspend";
    # lidSwitchExternalPower = "lock";
    # powerKey = "ignore";
    extraConfig = ''
      # don’t shutdown when power button is short-pressed
      HandlePowerKey=ignore
      HandleLidSwitch=hibernate
      HandleLidSwitchDocked=ignore
      HandleLidSwitchExternalPower=lock
    '';
  };

  hardware.graphics.enable = true;

  services.auto-cpufreq.enable = false;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  system.stateVersion = "24.05";
}
