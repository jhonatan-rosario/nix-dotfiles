{ lib, pkgs, ... }:
{
  imports = [ ../common ];

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      # Define as fontes de entrada. O formato é um par (tipo, nome).
      # 'us+intl' é o identificador para US International com dead keys.
      sources = [
        (lib.gvariant.mkTuple [
          "xkb"
          "us+intl"
        ])
      ];

      # Opcional: permite ver todos os layouts disponíveis na busca do GNOME
      show-all-sources = true;
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
    config = {
      common = {
        default = [
          "gnome"
        ];
      };
    };
  };
}
