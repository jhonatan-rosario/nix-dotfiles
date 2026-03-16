{
  config,
  pkgs,
  lib,
  outputs,
  ...
}: 
let
  inherit (config.colorscheme) palette;
  rgb = color: "rgb(${lib.removePrefix "#" color})";
  rgba = color: alpha: "rgba(${lib.removePrefix "#" color}${alpha})";
in {
  wayland.windowManager.hyprland = {
    plugins = [pkgs.hyprlandPlugins.hyprbars];
    settings = {
      "plugin:hyprbars" = {
        bar_height = 25;
        # bar_color = "rgb(2A2B2F)";
        bar_color = rgb palette.base01;
        "col.text" = rgb palette.base05;
        bar_text_font = config.fontProfiles.regular.name;
        bar_text_size = config.fontProfiles.regular.size;
        bar_part_of_window = true;
        bar_precedence_over_border = true;
        bar_buttons_alignment = "left";
        hyprbars-button = let
          closeAction = "hyprctl dispatch killactive";

          isOnSpecial = ''hyprctl activewindow -j | jq -re 'select(.workspace.name == "special")' >/dev/null'';
          moveToSpecial = "hyprctl dispatch movetoworkspacesilent special";
          moveToActive = "hyprctl dispatch movetoworkspacesilent name:$(hyprctl -j activeworkspace | jq -re '.name')";
          minimizeAction = "${isOnSpecial} && ${moveToActive} || ${moveToSpecial}";

          maximizeAction = "hyprctl dispatch fullscreen 1";
        in [
          # Red close button
          "rgb(DB504F),12,,${closeAction}"
          # "${rgb palette.base08},12,,${closeAction}"
          # Yellow "minimize" (send to special workspace) button
          "rgb(C6A72C),12,,${minimizeAction}"
          # "${rgb palette.base0A},12,,${minimizeAction}"
          # Green "maximize" (fullscreen) button
          "rgb(48A92E),12,,${maximizeAction}"
          # "${rgb palette.base0B},12,,${maximizeAction}"
        ];
      };

      # windowrulev2 = [
      #   "plugin:hyprbars:bar_color ${rgba config.colorscheme.colors.primary "ee"}, focus:1"
      #   "plugin:hyprbars:title_color ${rgb config.colorscheme.colors.on_primary}, focus:1"
      # ] ++ (lib.flatten (lib.mapAttrsToList (name: colors: [
      #   "plugin:hyprbars:bar_color ${rgba colors.primary_container "dd"}, title:^(\\[${name}\\])"
      #   "plugin:hyprbars:title_color ${rgb colors.on_primary_container}, title:^(\\[${name}\\])"

      #   "plugin:hyprbars:bar_color ${rgba colors.primary "ee"}, title:^(\\[${name}\\]), focus:1"
      #   "plugin:hyprbars:title_color ${rgb colors.on_primary}, title:^(\\[${name}\\]), focus:1"
      # ]) remoteColorschemes));
    };
  };
}
