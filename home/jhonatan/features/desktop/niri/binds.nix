# Conteúdo do `binds { }` do niri, no formato que o
# `wayland.windowManager.niri.settings` espera (attrset -> KDL).
#
# Convenções do gerador (lib.hm.generators.toKDL):
#   * `{ }`            -> nó sem argumentos:  close-window
#   * escalar          -> nó com 1 argumento: focus-workspace 1
#   * lista            -> nó com N argumentos: spawn "prog" "--flag"
#   * `_props`         -> propriedades no nó: Mod+Q repeat=false { ... }
#
# A referência é a config do hyprland (basic-binds.nix + default.nix +
# hyprland-with-noctalia.nix). Onde o atalho do hyprland colidia com um atalho
# essencial do niri, o desvio está comentado na linha correspondente.
{
  lib,
  pkgs,
  config,
  scripts,
}:
let
  noctaliaExe = lib.getExe' config.programs.noctalia.package "noctalia";
  ghosttyExe = lib.getExe config.programs.ghostty.package;
  handlrExe = lib.getExe pkgs.handlr-regex;

  # $VISUAL = "zeditor -w"; o `spawn` do niri não passa por shell, então cada
  # argumento é uma string separada.
  zeditorExe = lib.getExe' config.programs.zed-editor.package "zeditor";

  screenshotExe = lib.getExe scripts.niri-screenshot;
  ocrExe = lib.getExe scripts.niri-ocr;
  colorpickerExe = lib.getExe scripts.niri-colorpicker;
  gamemodeExe = lib.getExe scripts.niri-gamemode;

  # `noctalia msg ...` — usamos spawn-sh porque vários subcomandos levam
  # argumentos com barra/dois-pontos e ficam mais legíveis em uma string só.
  noctalia = args: { spawn-sh = "${noctaliaExe} msg ${args}"; };
  noctaliaLocked = args: (noctalia args) // { _props.allow-when-locked = true; };

  defaultApp = type: {
    spawn = [
      handlrExe
      "launch"
      type
    ];
  };

  # Mapeia as direções hjkl/setas do hyprland para as ações do niri.
  directions = [
    {
      key = "H";
      arrow = "Left";
      focus = "focus-column-left";
      move = "move-column-left";
      monitor = "focus-monitor-left";
      columnToMonitor = "move-column-to-monitor-left";
      workspaceToMonitor = "move-workspace-to-monitor-left";
    }
    {
      key = "J";
      arrow = "Down";
      focus = "focus-window-down";
      move = "move-window-down";
      monitor = "focus-monitor-down";
      columnToMonitor = "move-column-to-monitor-down";
      workspaceToMonitor = "move-workspace-to-monitor-down";
    }
    {
      key = "K";
      arrow = "Up";
      focus = "focus-window-up";
      move = "move-window-up";
      monitor = "focus-monitor-up";
      columnToMonitor = "move-column-to-monitor-up";
      workspaceToMonitor = "move-workspace-to-monitor-up";
    }
    {
      key = "L";
      arrow = "Right";
      focus = "focus-column-right";
      move = "move-column-right";
      monitor = "focus-monitor-right";
      columnToMonitor = "move-column-to-monitor-right";
      workspaceToMonitor = "move-workspace-to-monitor-right";
    }
  ];

  workspaces = map toString (lib.range 1 9);

  # Um nó de ação sem argumentos, ex.: { focus-column-left = { }; }
  act = name: { ${name} = { }; };

  # Atalhos gerados por direção/workspace. Cada grupo usa um prefixo de tecla
  # distinto, então não há sobreposição entre eles nem com os atalhos escritos
  # à mão abaixo.
  directional = lib.listToAttrs (
    lib.concatMap (d: [
      # hyprland: SUPER+hjkl/setas -> movefocus
      (lib.nameValuePair "Mod+${d.key}" (act d.focus))
      (lib.nameValuePair "Mod+${d.arrow}" (act d.focus))

      # hyprland: SUPERSHIFT+hjkl -> swapwindow
      (lib.nameValuePair "Mod+Shift+${d.key}" (act d.move))
      (lib.nameValuePair "Mod+Shift+${d.arrow}" (act d.move))

      # hyprland: SUPER+CTRL+SHIFT+hjkl -> movecurrentworkspacetomonitor
      (lib.nameValuePair "Mod+Ctrl+Shift+${d.key}" (act d.workspaceToMonitor))
      (lib.nameValuePair "Mod+Ctrl+Shift+${d.arrow}" (act d.workspaceToMonitor))
    ]) directions
  );

  # Foco e movimentação de colunas entre monitores:
  # Mod+Alt+hjkl / Mod+Alt+setas -> foca o monitor adjacente
  # Mod+Alt+Shift+hjkl / Mod+Alt+Shift+setas -> move a coluna para o monitor adjacente
  monitors = lib.listToAttrs (
    lib.concatMap (d: [
      (lib.nameValuePair "Mod+Alt+${d.key}" (act d.monitor))
      (lib.nameValuePair "Mod+Alt+${d.arrow}" (act d.monitor))
      (lib.nameValuePair "Mod+Alt+Shift+${d.key}" (act d.columnToMonitor))
      (lib.nameValuePair "Mod+Alt+Shift+${d.arrow}" (act d.columnToMonitor))
    ]) directions
  );

  workspaceBinds = lib.listToAttrs (
    lib.concatMap (n: [
      # hyprland: SUPER+N -> workspace N
      (lib.nameValuePair "Mod+${n}" { focus-workspace = lib.toInt n; })
      # hyprland: SUPERSHIFT+N -> movetoworkspacesilent N
      (lib.nameValuePair "Mod+Shift+${n}" { move-window-to-workspace = lib.toInt n; })
    ]) workspaces
  );
in
{
  # ---- Ajuda -------------------------------------------------------------
  "Mod+Shift+Slash".show-hotkey-overlay = { };

  # ---- Programas (hyprland: SUPER+RETURN/e/b/z) --------------------------
  "Mod+Return" = {
    _props.hotkey-overlay-title = "Abrir um terminal: ghostty";
    spawn = [
      ghosttyExe
      "+new-window"
    ];
  };
  "Mod+E" = {
    _props.hotkey-overlay-title = "Editor: zed";
    spawn = [
      zeditorExe
      "-w"
    ];
  };
  "Mod+B" = (defaultApp "x-scheme-handler/https") // {
    _props.hotkey-overlay-title = "Navegador";
  };
  "Mod+Z" = (defaultApp "inode/directory") // {
    _props.hotkey-overlay-title = "Gerenciador de arquivos";
  };
  # hyprland: SUPER+SPACE -> hyprctl switchxkblayout all next
  "Mod+Space".switch-layout = "next";

  # ---- Noctalia (paridade com hyprland-with-noctalia.nix) ----------------
  # hyprland: ALT_L+SPACE
  "Alt+Space" = noctalia "panel-toggle launcher";
  # hyprland: ALT+F4
  "Alt+F4" = noctalia "panel-toggle session";
  # Bloqueio de tela: Mod+Alt+BackSpace (libera Mod+Alt+L para focar monitor direito)
  "Mod+Alt+BackSpace" = noctaliaLocked "session lock";
  # hyprland: SUPER+V
  "Mod+V" = noctalia "panel-toggle clipboard";
  # hyprland: ALT_L+TAB (o switcher nativo do niri fica no Mod+Tab)
  "Alt+Tab" = noctalia "window-switcher";
  # hyprland: SUPER+F1
  "Mod+F1" = noctalia "power-cycle";
  # hyprland: SUPER+R (o switch-preset-column-width do niri foi para o Mod+S)
  "Mod+R" = noctalia "plugin noctalia/screen_recorder:service all toggle";
  # hyprland: SUPER+N
  "Mod+N" = noctalia "panel-toggle noctalia/notes:panel";

  # ---- Monitores (ciclo rápido independente de posição) ------------------
  "Mod+Backslash".focus-monitor-next = { };
  "Mod+Shift+Backslash".focus-monitor-previous = { };

  # ---- Mídia, volume e brilho (via noctalia) -----------------------------
  "XF86MonBrightnessUp" = noctaliaLocked "brightness-up all 10";
  "XF86MonBrightnessDown" = noctaliaLocked "brightness-down all 10";
  "XF86AudioRaiseVolume" = noctaliaLocked "volume-up 10";
  "XF86AudioLowerVolume" = noctaliaLocked "volume-down 10";
  "Shift+XF86AudioRaiseVolume" = noctaliaLocked "volume-up 20";
  "Shift+XF86AudioLowerVolume" = noctaliaLocked "volume-down 20";
  "XF86AudioMute" = noctaliaLocked "volume-mute";
  "XF86AudioMicMute" = noctaliaLocked "mic-mute";
  "XF86AudioPlay" = noctaliaLocked "media toggle";
  "XF86AudioNext" = noctaliaLocked "media next";
  "XF86AudioPrev" = noctaliaLocked "media previous";
  "XF86AudioStop" = noctaliaLocked "media stop";

  # ---- Captura de tela, OCR e conta-gotas --------------------------------
  # hyprland: ,Print -> screenshot-satty area
  "Print".spawn = [
    screenshotExe
    "region"
  ];
  # hyprland: SUPERSHIFT+Print -> screenshot-satty output
  "Mod+Shift+Print".spawn = [
    screenshotExe
    "output"
  ];
  # UI nativa do niri (congela a tela; salva em ~/Pictures/Screenshots)
  "Mod+Print".screenshot = { };
  "Ctrl+Print".screenshot-screen = { };
  "Alt+Print".screenshot-window = { };
  # hyprland: SUPERSHIFT+t
  "Mod+Shift+T".spawn = ocrExe;
  # hyprland: SUPERSHIFT+c -> hyprpicker -a
  "Mod+Shift+C".spawn = colorpickerExe;
  # hyprland: SUPER+F4 -> gamemode
  "Mod+F4".spawn = gamemodeExe;

  # ---- Sessão ------------------------------------------------------------
  # hyprland: SUPERSHIFT+e -> exit
  "Mod+Shift+E".quit = { };
  "Ctrl+Alt+Delete".quit = { };
  "Mod+Shift+P".power-off-monitors = { };
  # hyprland: submap "passthrough" no SUPER+esc
  "Mod+Escape" = {
    _props.allow-inhibiting = false;
    toggle-keyboard-shortcuts-inhibit = { };
  };

  # ---- Janelas -----------------------------------------------------------
  # hyprland: SUPER+q / SUPER+mouse:274
  "Mod+Q" = {
    _props.repeat = false;
    close-window = { };
  };
  "Mod+MouseMiddle".close-window = { };
  # hyprland: SUPER+f (fullscreen,1 = maximiza) e SUPERSHIFT+f (fullscreen,0)
  "Mod+F".maximize-column = { };
  "Mod+Shift+F".fullscreen-window = { };
  "Mod+M".maximize-window-to-edges = { };
  "Mod+Ctrl+F".expand-column-to-available-width = { };
  "Mod+C".center-column = { };
  "Mod+Ctrl+C".center-visible-columns = { };
  # hyprland: SUPERSHIFT+space -> togglefloating
  "Mod+Shift+Space".toggle-window-floating = { };
  "Mod+Ctrl+Space".switch-focus-between-floating-and-tiling = { };
  # hyprland: SUPER+g -> togglegroup (colunas em abas são o análogo no niri)
  "Mod+G".toggle-column-tabbed-display = { };
  "Mod+W".toggle-column-tabbed-display = { };
  # hyprexpo
  "Mod+O" = {
    _props.repeat = false;
    toggle-overview = { };
  };

  # ---- Tamanho de colunas/janelas (niri usa Mod+R; movido para o Mod+S) ---
  "Mod+S".switch-preset-column-width = { };
  "Mod+Shift+S".switch-preset-column-width-back = { };
  "Mod+Ctrl+S".switch-preset-window-height = { };
  "Mod+Ctrl+Shift+S".reset-window-height = { };
  "Mod+Minus".set-column-width = "-10%";
  "Mod+Equal".set-column-width = "+10%";
  "Mod+Shift+Minus".set-window-height = "-10%";
  "Mod+Shift+Equal".set-window-height = "+10%";

  # ---- Entrar e sair de colunas ------------------------------------------
  "Mod+BracketLeft".consume-or-expel-window-left = { };
  "Mod+BracketRight".consume-or-expel-window-right = { };
  "Mod+Comma".consume-window-into-column = { };
  "Mod+Period".expel-window-from-column = { };

  # hyprland: SUPERCTRL+hjkl -> movewindoworgroup
  "Mod+Ctrl+H".consume-or-expel-window-left = { };
  "Mod+Ctrl+L".consume-or-expel-window-right = { };
  "Mod+Ctrl+J".move-window-down = { };
  "Mod+Ctrl+K".move-window-up = { };

  # ---- Colunas: primeira/última -----------------------------------------
  "Mod+Home".focus-column-first = { };
  "Mod+End".focus-column-last = { };
  "Mod+Ctrl+Home".move-column-to-first = { };
  "Mod+Ctrl+End".move-column-to-last = { };

  # ---- Workspaces --------------------------------------------------------
  "Mod+U".focus-workspace-down = { };
  "Mod+I".focus-workspace-up = { };
  "Mod+Page_Down".focus-workspace-down = { };
  "Mod+Page_Up".focus-workspace-up = { };
  "Mod+Ctrl+U".move-column-to-workspace-down = { };
  "Mod+Ctrl+I".move-column-to-workspace-up = { };
  "Mod+Ctrl+Page_Down".move-column-to-workspace-down = { };
  "Mod+Ctrl+Page_Up".move-column-to-workspace-up = { };
  "Mod+Shift+U".move-workspace-down = { };
  "Mod+Shift+I".move-workspace-up = { };
  "Mod+Shift+Page_Down".move-workspace-down = { };
  "Mod+Shift+Page_Up".move-workspace-up = { };
  # hyprland: SUPER+apostrophe / SUPER+dead_grave -> workspace previous
  "Mod+Apostrophe".focus-workspace-previous = { };
  "Mod+Dead_grave".focus-workspace-previous = { };
  "Mod+Grave".focus-workspace-previous = { };

  # ---- Roda do mouse -----------------------------------------------------
  "Mod+WheelScrollDown" = {
    _props.cooldown-ms = 150;
    focus-workspace-down = { };
  };
  "Mod+WheelScrollUp" = {
    _props.cooldown-ms = 150;
    focus-workspace-up = { };
  };
  "Mod+Ctrl+WheelScrollDown" = {
    _props.cooldown-ms = 150;
    move-column-to-workspace-down = { };
  };
  "Mod+Ctrl+WheelScrollUp" = {
    _props.cooldown-ms = 150;
    move-column-to-workspace-up = { };
  };
  "Mod+WheelScrollRight".focus-column-right = { };
  "Mod+WheelScrollLeft".focus-column-left = { };
  "Mod+Ctrl+WheelScrollRight".move-column-right = { };
  "Mod+Ctrl+WheelScrollLeft".move-column-left = { };
  "Mod+Shift+WheelScrollDown".focus-column-right = { };
  "Mod+Shift+WheelScrollUp".focus-column-left = { };
}
// directional
// monitors
// workspaceBinds
