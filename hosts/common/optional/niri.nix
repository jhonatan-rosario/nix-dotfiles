# Window Manager: niri (scrollable-tiling)
#
# Usa o módulo `programs.niri` do nixpkgs, que cuida da parte de sistema:
# registra a sessão para o greeter, instala as units do systemd, os portais
# recomendados pelo upstream (gnome + gtk) e o gnome-keyring.
#
# A config do compositor em si fica no home-manager, em
# home/jhonatan/features/desktop/niri/ (módulo `wayland.windowManager.niri`).
# Os dois lados são complementares: o módulo do home-manager não consegue
# registrar uma sessão para o display manager, e o do NixOS não gera config.
#
# Este módulo convive sem problemas com ../optional/hyprland.nix: os dois
# registram suas sessões em services.displayManager.sessionPackages, então
# "Hyprland" e "Niri" aparecem juntos no greeter e a escolha é feita no login.
# O que os dois módulos definem em comum (keyring, thunar, gvfs, ...) é
# repetido aqui de forma idempotente, para que comentar a importação do
# hyprland não deixe o sistema sem essas peças.
{
  lib,
  pkgs,
  ...
}:
{
  programs.niri = {
    enable = true;

    # O gerenciador de arquivos aqui é o Thunar; sem o Nautilus o portal usa o
    # FileChooser do GTK (mesmo comportamento da sessão do hyprland).
    useNautilus = false;
  };

  environment.systemPackages = with pkgs; [
    # O niri cria o socket X11 e sobe o xwayland-satellite sob demanda desde a
    # 25.08 — basta o binário estar no PATH.
    xwayland-satellite

    libsecret # Opcional: guardar senhas no GNOME keyring
    file-roller # GUI Archive Manager (used by thunar-archive-plugin)
    p7zip
    unrar
    unzip
    zip
  ];

  services.gvfs.enable = true; # Montagem, lixeira e afins
  services.tumbler.enable = true; # Miniaturas de imagens

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  programs.seahorse.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
      xdg-desktop-portal-termfilechooser
    ];
    config = {
      common = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
      };
      niri = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = lib.mkForce [ "termfilechooser" ];
      };
    };
  };

  # O greeter (greetd + noctalia-greeter) vem de ../optional/hyprland.nix.
  # `inputs.noctalia-greeter.nixosModules.default` é um módulo anônimo, então
  # importá-lo dos dois arquivos duplicaria a definição de
  # `programs.noctalia-greeter.package`. Se você comentar a importação do
  # hyprland em hosts/voyager/default.nix, descomente o bloco abaixo para o
  # sistema continuar tendo tela de login.
  #
  # imports = [ inputs.noctalia-greeter.nixosModules.default ];
  #
  # programs.noctalia-greeter = {
  #   enable = true;
  #   greeter-args = "";
  #   settings = {
  #     session.default = "Niri";
  #     appearance.schema = "Catppuccin";
  #     output.name = "eDP-1";
  #     cursor = {
  #       theme = "Catppuccin-GTK-Dark";
  #       size = 24;
  #       path = "${pkgs.catppuccin-cursors.macchiatoDark}/share/icons";
  #     };
  #     keyboard.layout = "us";
  #   };
  # };
}
