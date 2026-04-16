{ ... }:
{
  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Ativa suporte a perfis de áudio modernos e bateria
        # Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
  # services.blueman.enable = true;

  environment.persistence = {
    "/persist".directories = [
      "/var/lib/bluetooth"
    ];
  };
}
