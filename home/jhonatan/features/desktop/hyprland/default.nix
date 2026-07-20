{
  lib,
  config,
  pkgs,
  ...
}:
let
  # getHostname = x: lib.last (lib.splitString "@" x);
  inherit (config.colorscheme) palette;
  rgb = color: "rgb(${lib.removePrefix "#" color})";
  rgba = color: alpha: "rgba(${lib.removePrefix "#" color}${alpha})";
  notifySendExe = lib.getExe' pkgs.libnotify "notify-send";
  tesseractExe = lib.getExe pkgs.tesseract;
  wlCopyExe = lib.getExe' pkgs.wl-clipboard "wl-copy";
  grimblastExe = lib.getExe pkgs.grimblast;
  sattyExe = lib.getExe pkgs.satty;
  ocr-extract-text = pkgs.writeShellScriptBin "ocr-extract-text" ''
    if ${grimblastExe} --freeze save area - | ${tesseractExe} stdin stdout -l por+eng 2>/dev/null | ${wlCopyExe}; then
      if [ -n "$(${wlCopyExe})" ]; then
        ${notifySendExe} "OCR Concluído" "O texto extraído foi copiado para a área de transferência." -i edit-paste -t 3000
      else
        ${notifySendExe} "OCR Falhou" "Nenhum texto pôde ser identificado na área selecionada." -i dialog-error -t 3000
      fi
    else
      ${notifySendExe} "OCR Cancelado" "A seleção de tela foi abortada" -i dialog-warning -t 2000
    fi
  '';
  screenshot-satty = pkgs.writeShellScriptBin "screenshot-satty" ''
    set -e

    # Captura o primeiro argumento passado para o script ($1).
    # Se nenhum argumento for passado, define o padrão como "area".
    MODE="''${1:-area}"

    # Cria um diretório temporário seguro
    TEMP_DIR=$(mktemp -d)
    FILE="$TEMP_DIR/screenshot.png"

    # Garante a remoção do diretório temporário ao encerrar o script
    trap 'rm -rf "'"$TEMP_DIR"'"' EXIT

    # Tira o print usando o modo dinâmico (area, output, screen, etc.)
    if ${grimblastExe} --freeze copysave "$MODE" "$FILE"; then
        # Passa a imagem salva para o Satty
        # ${wlCopyExe} < "$FILE"
        ${sattyExe} --filename "$FILE"

    fi
  '';
  gamemode = pkgs.writeShellScriptBin "gamemode" ''
    set -e
    HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
    if [ "$HYPRGAMEMODE" = 1 ] ; then
        hyprctl --batch "\
            keyword animations:enabled 0;\
            keyword animation borderangle,0; \
            keyword decoration:shadow:enabled 0;\
            keyword decoration:blur:enabled 0"
        hyprctl notify 1 5000 "rgb(40a02b)" "Gamemode [ON]"
        exit
    else
        hyprctl notify 1 5000 "rgb(d20f39)" "Gamemode [OFF]"
        hyprctl reload
        exit 0
    fi
    exit 1
  '';
  ocrExe = lib.getExe ocr-extract-text;
  screenshotExe = lib.getExe screenshot-satty;
  gamemodeExe = lib.getExe gamemode;
in
{
  imports = [
    ../common
    ../common/wayland-wm
    ./basic-binds.nix
    ./hyprland-with-noctalia.nix
  ];

  home.packages = with pkgs; [
    grimblast
    satty
    hyprpicker
    tesseract
    screenshot-satty
    ocr-extract-text
    gamemode
  ];

  home.sessionVariables = {
    GRIMBLAST_EDITOR = "satty";
  };

  # xdg.configFile."uwsm/env".source =
  #   "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };

    package = null;
    portalPackage = null;

    settings = {
      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      general = {
        layout = "dwindle";

        "col.active_border" = rgb palette.base07;
        "col.inactive_border" = rgb palette.base04;

        border_size = 2;
        allow_tearing = true;
        resize_on_border = true;
      };

      monitor = ",preferred,auto,1";

      windowrule = [
        "match:title ^(Picture-in-Picture)$, float on"
        "match:title ^(Picture-in-Picture)$, pin on"
        "match:title ^(Picture-in-Picture)$, size 730 430"
        "match:title ^(Picture in picture)$, float on"
        "match:title ^(Picture in picture)$, pin on"
        "match:title ^(Picture in picture)$, size 730 430"
        "match:title ^(filechooser)$, float on"
        "match:title ^(filechooser)$, size 1555 865"
        "match:title ^(satty)$, float on"
        "match:title ^(satty)$, pin on"
      ];

      layerrule = [
        "animation fade, match:namespace hyprpicker"
        "animation fade, match:namespace selection"
      ];

      animations = {
        enabled = true;
        bezier = [
          "easein,0.1, 0, 0.5, 0"
          "easeinback,0.35, 0, 0.95, -0.3"

          "easeout,0.5, 1, 0.9, 1"
          "easeoutback,0.35, 1.35, 0.65, 1"

          "easeinout,0.45, 0, 0.55, 1"
        ];

        animation = [
          "fadeIn,1,3,easeout"
          "fadeLayersIn,1,3,easeoutback"
          "layersIn,1,3,easeoutback,slide"
          "windowsIn,1,3,easeoutback,slide"

          "fadeLayersOut,1,3,easeinback"
          "fadeOut,1,3,easein"
          "layersOut,1,3,easeinback,slide"
          "windowsOut,1,3,easeinback,slide"

          "border,1,3,easeout"
          "fadeDim,1,3,easeinout"
          "fadeShadow,1,3,easeinout"
          "fadeSwitch,1,3,easeinout"
          "windowsMove,1,3,easeoutback"
          "workspaces,1,2.6,easeoutback,slide"
        ];
      };

      exec-once = [
        "ghostty --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false"
      ];

      group = {
        "col.border_active" = rgb palette.base07;
        "col.border_inactive" = rgb palette.base04;
        "col.border_locked_active" = rgb palette.base09;
        "col.border_locked_inactive" = rgb palette.base04;
        groupbar.font_size = 11;

        groupbar = {
          height = 8;
          render_titles = false;
          "col.active" = rgb palette.base0E;
          "col.inactive" = rgba palette.base0E "80"; # 50%
          "col.locked_active" = rgb palette.base09;
          "col.locked_inactive" = rgb palette.base04;
        };
      };

      binds = {
        movefocus_cycles_fullscreen = false;
      };

      cursor = {
        no_warps = true;
        inactive_timeout = 4;
      };

      input = {
        kb_layout = config.home.keyboard.layout;
        kb_variant = config.home.keyboard.variant;
        kb_options = config.home.keyboard.options;
        numlock_by_default = true;
        follow_mouse = 2;
        float_switch_override_focus = 0;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
        };
      };

      dwindle = {
        split_width_multiplier = 1.35;
      };

      misc = {
        close_special_on_empty = true;
        focus_on_activate = true;
        key_press_enables_dpms = true;
        # Unfullscreen when opening something
        on_focus_under_fullscreen = 2;
      };

      bind =
        let
          defaultApp = type: "${lib.getExe pkgs.handlr-regex} launch ${type}";
          defaultVisualEditor = config.home.sessionVariables.VISUAL;
          defaultEditor = config.home.sessionVariables.EDITOR;
        in
        [
          # Program bindings
          "SUPER,RETURN,exec,ghostty +new-window"
          "SUPER,e,exec,${defaultVisualEditor}"
          "SUPERSHIFT,e,exec,${defaultEditor}"
          "SUPER,b,exec,${defaultApp "x-scheme-handler/https"}"
          "SUPER,z,exec,${defaultApp "inode/directory"}"

          # Switch keyboard layout
          "SUPER,SPACE,exec,hyprctl switchxkblayout all next"

          # Hyprpicker
          "SUPERSHIFT,c,exec,hyprpicker -a"

          # Screenshotting
          ",Print,exec,${screenshotExe} area"
          "SUPERSHIFT,Print,exec,${screenshotExe} output"

          # Text OCR
          "SUPERSHIFT,t,exec,${ocrExe}"

          # Gamemode
          "SUPER,F4,exec,${gamemodeExe}"
        ];

      extraConfig = ''
        # Passthrough mode (e.g. for VNC)
        bind=SUPER,esc,submap,passthrough
        submap=passthrough
        bind=SUPER,esc,submap,reset
        submap=reset
      '';
    };
  };
}
