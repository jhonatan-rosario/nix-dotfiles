{ ... }:
{
  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  # services.blueman.enable = true;

  environment.persistence = {
    "/persist".directories = [
      "/var/lib/bluetooth"
    ];
  };
}
