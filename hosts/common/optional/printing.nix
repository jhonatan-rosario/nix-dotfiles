{ pkgs, ... }:
{
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      # cups-browsed
      epson-escpr2
    ];
  };

  # hardware.printers = {
  #   ensureDefaultPrinter = "Epson_L3250_TI";
  #   ensurePrinters = [
  #     {
  #       name = "Epson_L3250_TI";
  #       description = "Epson L3250";
  #       location = "TI";
  #       deviceUri = "ipp://192.168.50.122:631/ipp/print";
  #       model = "everywhere";
  #     }
  #   ];
  # };
}
