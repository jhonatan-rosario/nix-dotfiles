{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.hardware.nixosModules.lenovo-thinkpad-e14-amd
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-laptop-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/jhonatan
    ../common/optional/hyprland.nix # Window Manager

    # ../common/optional/gnome.nix # Desktop Environment
    # ../common/optional/plasma.nix # Desktop Environment
    # ../common/optional/disable-nvidia.nix
    # ../common/optional/encrypted-root.nix

    ../common/optional/pipewire.nix
    ../common/optional/podman.nix
    ../common/optional/docker.nix
    ../common/optional/printing.nix
    ../common/optional/quietboot.nix
    ../common/optional/fingerprint.nix
    ../common/optional/bluetooth.nix
    ../common/optional/virtual-machine.nix
    ../common/optional/flatpak.nix
    ../common/optional/openvpn.nix
    ../common/optional/default-packages.nix
    ../common/optional/noctalia.nix
    # ../common/optional/samba.nix
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
    dconf.enable = true;
    git.enable = true;
  };

  # Lid settings
  services.logind.settings.Login = {
    HandlePowerKey = "hibernate";
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "lock";
    HandleLidSwitchDocked = "ignore";
    # extraConfig = ''
    #   # don’t shutdown when power button is short-pressed
    #   HandlePowerKey=ignore
    #   HandleLidSwitch=hibernate
    #   HandleLidSwitchDocked=ignore
    #   HandleLidSwitchExternalPower=ignore
    # '';
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.power-profiles-daemon.enable = true;

  # services.auto-cpufreq.enable = true;
  # services.auto-cpufreq.settings = {
  #   battery = {
  #     governor = "powersave";
  #     turbo = "never";
  #   };
  #   charger = {
  #     governor = "performance";
  #     "platform_profile" = "balanced";
  #     turbo = "auto";
  #   };
  # };

  system.stateVersion = "25.11";
}
