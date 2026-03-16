{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #   version = "565.57.01";
    #    sha256_64bit = "sha256-buvpTlheOF6IBPWnQVLfQUiHv4GcwhvZW3Ks0PsYLHo=";
    #    sha256_aarch64 = "";
    #    openSha256 = "";
    #    settingsSha256 = "sha256-H7uEe34LdmUFcMcS6bz7sbpYhg9zPCb/5AmZZFTx1QA=";
    #    persistencedSha256 = "";
    # };

    # Nvidia Optimus PRIME. It is a technology developed by Nvidia to optimize
    # the power consumption and performance of laptops equipped with their GPUs.
    # It seamlessly switches between the integrated graphics,
    # usually from Intel, for lightweight tasks to save power,
    # and the discrete Nvidia GPU for performance-intensive tasks.
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # FIXME: Change the following values to the correct Bus ID values for your system!
      # More on "https://wiki.nixos.org/wiki/Nvidia#Configuring_Optimus_PRIME:_Bus_ID_Values_(Mandatory)"
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };

  # Set environment variables related to NVIDIA graphics
  environment.variables = {
    # Required to run the correct GBM backend for nvidia GPUs on wayland
    # GBM_BACKEND = "nvidia-drm";
    # Apparently, without this nouveau may attempt to be used instead
    # (despite it being blacklisted)
    __GLX_VENDOR_LIBRARY_NAME = "nvidia"; # OK Brave, Android No
    # Hardware cursors are currently broken on nvidia
    LIBVA_DRIVER_NAME = "nvidia";
    # WLR_NO_HARDWARE_CURSORS = "1";
    # NIXOS_OZONE_WL = "1";
    # __GL_THREADED_OPTIMIZATION = "1";
    # __GL_SHADER_CACHE = "1";
  };

  # Packages related to NVIDIA graphics
  environment.systemPackages = with pkgs; [
    clinfo
    gwe
    # nvtop-nvidia
    nvtopPackages.nvidia
    virtualglLib
    vulkan-loader
    vulkan-tools
  ];

  nixpkgs.config.nvidia.acceptLicense = true;

  # NixOS specialization named 'nvidia-sync'. Provides the ability
  # to switch the Nvidia Optimus Prime profile
  # to sync mode during the boot process, enhancing performance.
  #   specialisation = {
  #     nvidia-sync.configuration = {
  #       system.nixos.tags = [ "nvidia-sync" ];
  #       hardware.nvidia = {
  #         powerManagement.finegrained = lib.mkForce false;
  #
  #         prime.offload.enable = lib.mkForce false;
  #         prime.offload.enableOffloadCmd = lib.mkForce false;
  #
  #         prime.sync.enable = lib.mkForce true;
  #         # Dynamic Boost. It is a technology found in NVIDIA Max-Q design laptops with RTX GPUs.
  #         # It intelligently and automatically shifts power between
  #         # the CPU and GPU in real-time based on the workload of your game or application.
  #         dynamicBoost.enable = lib.mkForce true;
  #       };
  #     };
  #   };
}
