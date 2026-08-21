# niri — compositor scrollable-tiling, usado com o noctalia shell v5.
#
# Divisão de responsabilidades, espelhando o que já é feito com o hyprland:
#   * hosts/common/optional/niri.nix -> módulo NixOS `programs.niri` (registra a
#     sessão no greeter, portais, keyring, units do systemd e o pacote);
#   * aqui -> módulo home-manager `wayland.windowManager.niri`, que gera o
#     ~/.config/niri/config.kdl a partir de `settings` e valida com
#     `niri validate` no tempo de build (checkConfig).
#
# Como no hyprland, `portalPackage` e `xwaylandSatellitePackage` ficam null e
# `systemd.enable = false`, porque essas peças já vêm do módulo NixOS. O
# `package` continua no default só para o checkConfig funcionar (é a mesma
# derivação do sistema, então não há duplicação real no store).
{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (config.colorScheme) palette;

  # O nix-colors entrega as cores sem "#".
  hex = color: "#${lib.removePrefix "#" color}";
  hexAlpha = color: alpha: "${hex color}${alpha}";

  scripts = import ./scripts.nix { inherit lib pkgs; };

  binds = import ./binds.nix {
    inherit
      lib
      pkgs
      config
      scripts
      ;
  };

  keyboard = config.home.keyboard;
  cursorTheme = config.gtk.cursorTheme;
in
{
  imports = [
    ../common
    ../common/wayland-wm
  ];

  home.packages =
    (with pkgs; [
      grim
      slurp
      satty
      tesseract
      jq
      wl-clipboard
      libnotify
    ])
    ++ (lib.attrValues scripts);

  wayland.windowManager.niri = {
    enable = true;

    # A sessão, os portais e as units vêm do módulo NixOS.
    portalPackage = null;
    xwaylandSatellitePackage = null;
    systemd.enable = false;

    settings = {
      input = {
        keyboard = {
          xkb = {
            inherit (keyboard) layout variant;
          }
          // lib.optionalAttrs (keyboard.options != null && keyboard.options != [ ]) {
            options = lib.concatStringsSep "," keyboard.options;
          };

          numlock = { };
        };

        touchpad = {
          tap = { };
          dwt = { }; # hyprland: touchpad.disable_while_typing
          natural-scroll = { };
        };

        # hyprland: input.follow_mouse = 2 (o foco segue o mouse sem levantar a
        # janela). max-scroll-amount="0%" limita ao que já está visível.
        focus-follows-mouse._props.max-scroll-amount = "0%";

        # hyprland: cursor.no_warps = true -> nada de warp-mouse-to-focus.
      };

      layout = {
        gaps = 10; # hyprland: gaps_in 5 / gaps_out 10
        center-focused-column = "never";

        preset-column-widths._children = [
          { proportion = 0.33333; }
          { proportion = 0.5; }
          { proportion = 0.66667; }
        ];

        default-column-width.proportion = 0.5;

        # O hyprland desenhava borda em todas as janelas (border_size 2), então
        # usamos `border` em vez do focus-ring (que só marca a janela ativa).
        focus-ring.off = { };

        border = {
          on = { };
          width = 2;
          active-color = hex palette.base07;
          inactive-color = hex palette.base04;
          urgent-color = hex palette.base08;
        };

        # hyprland: decoration.shadow
        shadow = {
          on = { };
          softness = 30;
          spread = 5;
          offset._props = {
            x = 0;
            y = 5;
          };
          color = "#1a1a1aee";
        };

        # hyprland: group.groupbar
        tab-indicator = {
          width = 4;
          gap = 5;
          length._props.total-proportion = 1.0;
          position = "left";
          active-color = hex palette.base0E;
          inactive-color = hex palette.base04;
          urgent-color = hex palette.base09;
        };

        insert-hint.color = hexAlpha palette.base07 "80";
      };

      # hyprland: exec-once = [ "noctalia" ]. O daemon do ghostty não precisa
      # aparecer aqui porque programs.ghostty.systemd.enable já cria um serviço
      # de usuário atrelado ao graphical-session.target.
      spawn-at-startup = lib.getExe' config.programs.noctalia.package "noctalia";

      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      hotkey-overlay.skip-at-startup = { };

      cursor = {
        xcursor-theme = cursorTheme.name;
        xcursor-size = cursorTheme.size;
        hide-after-inactive-ms = 4000; # hyprland: cursor.inactive_timeout = 4
      };

      overview = {
        zoom = 0.5;
        # backdrop-color = hex palette.base00;
      };

      # O noctalia pede o blur pelo protocolo ext-background-effect-v1, que o
      # niri 26.04 implementa; não é preciso layer-rule para isso (era o que a
      # layerrule do hyprland fazia). Aqui só ajustamos a qualidade.
      # hyprland: decoration.blur = { size 3; passes 2; }
      blur = {
        passes = 2;
        offset = 3;
        noise = 0.02;
        saturation = 1.5;
      };

      # Alt+Tab fica com o window-switcher do noctalia (paridade com o
      # hyprland); o switcher nativo do niri responde no Mod+Tab.
      recent-windows = {
        highlight = {
          corner-radius = 14;
          active-color = hex palette.base07;
          urgent-color = hex palette.base08;
        };

        binds = {
          "Mod+Tab".next-window = { };
          "Mod+Shift+Tab".previous-window = { };
        };
      };

      inherit binds;

      # Nós que aparecem mais de uma vez (ou cuja ordem relativa importa) vão em
      # `_children`, que o gerador emite na ordem da lista.
      _children = [
        # Coloca apenas o backdrop do noctalia no fundo da Overview do Niri.
        # O wallpaper principal (noctalia-wallpaper) renderiza no desktop normalmente.
        {
          layer-rule = {
            match._props.namespace = "^noctalia-backdrop$";
            place-within-backdrop = true;
          };
        }

        # hyprland: decoration.rounding = 20
        {
          window-rule = {
            geometry-corner-radius = 20;
            clip-to-geometry = true;
          };
        }

        {
          window-rule = {
            match._props.app-id = "dev.noctalia.Noctalia";
            open-floating = true;
            default-column-width.fixed = 1080;
            default-window-height.fixed = 920;
          };
        }

        # hyprland: windowrule Picture-in-Picture -> float + pin + 730x430
        {
          window-rule = {
            _children = [
              { match._props.title = "^Picture-in-Picture$"; }
              { match._props.title = "^Picture in picture$"; }
            ];
            open-floating = true;
            default-column-width.fixed = 730;
            default-window-height.fixed = 430;
          };
        }

        # hyprland: windowrule filechooser -> float + 1555x865
        {
          window-rule = {
            match._props.title = "^filechooser$";
            open-floating = true;
            default-column-width.fixed = 1555;
            default-window-height.fixed = 865;
          };
        }

        # hyprland: windowrule satty -> float + pin
        {
          window-rule = {
            match._props.app-id = "^com\\.gabm\\.satty$";
            open-floating = true;
          };
        }
      ];
    };

    # extraConfigEarly = ''
    #   // Rode `niri msg outputs` para ver nomes e modos disponíveis. O hyprland
    #   // usava `monitor = ",preferred,auto,1"`, que é o padrão automático aqui.
    #   /-output "eDP-1" {
    #       mode "1920x1080"
    #       scale 1
    #   }
    # '';

    # Includes são posicionais e sobrescrevem o que veio antes, por isso vão no
    # extraConfig (que o módulo concatena depois de tudo).
    extraConfig = ''
      // Cores geradas pelo template "niri" do noctalia (o arquivo é criado em
      // runtime, daí o optional=true).
      include optional=true "~/.config/niri/noctalia.kdl"

      // Escrito/limpo pelo niri-gamemode (Mod+F4).
      include optional=true "~/.config/niri/gamemode.kdl"
    '';
  };
}
