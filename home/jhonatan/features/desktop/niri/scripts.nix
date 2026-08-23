# Utilitários usados pelos atalhos do niri.
#
# São os equivalentes dos scripts do hyprland (que dependem de hyprctl e do
# grimblast), reescritos em cima do grim/slurp e do IPC do niri. Os nomes têm
# o prefixo "niri-" justamente para poderem conviver no mesmo profile com os
# scripts do hyprland.
{ lib, pkgs }:
let
  grimExe = lib.getExe pkgs.grim;
  slurpExe = lib.getExe pkgs.slurp;
  wayfreezeExe = lib.getExe pkgs.wayfreeze;
  sattyExe = lib.getExe pkgs.satty;
  tesseractExe = lib.getExe pkgs.tesseract;
  jqExe = lib.getExe pkgs.jq;
  niriExe = lib.getExe pkgs.niri;
  wlCopyExe = lib.getExe' pkgs.wl-clipboard "wl-copy";
  notifySendExe = lib.getExe' pkgs.libnotify "notify-send";
in
{
  # Print / Mod+Shift+Print: captura e abre no satty para anotação.
  niri-screenshot = pkgs.writeShellScriptBin "niri-screenshot" ''
    set -eu

    # "region" (padrão) ou "output".
    MODE="''${1:-region}"

    TEMP_DIR=$(mktemp -d)
    FILE="$TEMP_DIR/screenshot.png"
    trap 'rm -rf "$TEMP_DIR"' EXIT

    case "$MODE" in
      region)
        ${wayfreezeExe} --hide-cursor &
        FREEZE_PID=$!
        trap 'kill "$FREEZE_PID" 2>/dev/null || true; rm -rf "$TEMP_DIR"' EXIT
        sleep 0.1

        GEOMETRY=$(${slurpExe} -d) || exit 0
        ${grimExe} -g "$GEOMETRY" "$FILE"
        kill "$FREEZE_PID" 2>/dev/null || true
        ;;
      output)
        OUTPUT=$(${niriExe} msg --json focused-output | ${jqExe} -r '.name')
        ${grimExe} -o "$OUTPUT" "$FILE"
        ;;
      *)
        echo "uso: niri-screenshot [region|output]" >&2
        exit 1
        ;;
    esac

    ${wlCopyExe} --type image/png < "$FILE"
    ${sattyExe} --filename "$FILE"
  '';

  # Mod+Shift+T: OCR da região selecionada para a área de transferência.
  niri-ocr = pkgs.writeShellScriptBin "niri-ocr" ''
    set -eu

    ${wayfreezeExe} --hide-cursor &
    FREEZE_PID=$!
    trap 'kill "$FREEZE_PID" 2>/dev/null || true' EXIT
    sleep 0.1

    GEOMETRY=$(${slurpExe} -d) || {
      ${notifySendExe} "OCR Cancelado" "A seleção de tela foi abortada" \
        -i dialog-warning -t 2000
      exit 0
    }

    TEXT=$(${grimExe} -g "$GEOMETRY" - \
      | ${tesseractExe} stdin stdout -l por+eng 2>/dev/null || true)

    kill "$FREEZE_PID" 2>/dev/null || true

    if [ -n "$TEXT" ]; then
      printf '%s' "$TEXT" | ${wlCopyExe}
      ${notifySendExe} "OCR Concluído" \
        "O texto extraído foi copiado para a área de transferência." \
        -i edit-paste -t 3000
    else
      ${notifySendExe} "OCR Falhou" \
        "Nenhum texto pôde ser identificado na área selecionada." \
        -i dialog-error -t 3000
    fi
  '';

  # Mod+Shift+C: equivalente ao "hyprpicker -a" usando o IPC do niri.
  niri-colorpicker = pkgs.writeShellScriptBin "niri-colorpicker" ''
    set -eu

    COLOR=$(${niriExe} msg pick-color | awk '/^Hex:/ { print $2 }')

    if [ -n "$COLOR" ]; then
      printf '%s' "$COLOR" | ${wlCopyExe}
      ${notifySendExe} "Cor copiada" "$COLOR" -i color-select -t 3000
    fi
  '';

  # Mod+F4: equivalente ao gamemode do hyprland.
  #
  # O niri não tem IPC para desligar animações em runtime, então escrevemos um
  # arquivo incluído pelo config.kdl (include optional=true). Como o niri
  # observa os includes, gravar/limpar o arquivo recarrega a config na hora.
  niri-gamemode = pkgs.writeShellScriptBin "niri-gamemode" ''
    set -eu

    FILE="''${XDG_CONFIG_HOME:-$HOME/.config}/niri/gamemode.kdl"
    mkdir -p "$(dirname "$FILE")"

    if [ -s "$FILE" ]; then
      : > "$FILE"
      ${notifySendExe} "Gamemode" "OFF" -i input-gaming -t 3000
    else
      printf 'animations {\n    off\n}\n' > "$FILE"
      ${notifySendExe} "Gamemode" "ON" -i input-gaming -t 3000
    fi
  '';
}
