{
  lib,
  config,
  nix-colors,
  ...
}:
{
  systemd.user.services.waybar = {
    Unit.StartLimitBurst = 30;
  };
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [
      {
        layer = "top";
        height = 28;
        spacing = 20;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];

        modules-center = [
          "clock"
          "custom/notification"
        ];

        modules-right = [
          "group/group-tray"
          "idle_inhibitor"
          "memory"
          "cpu"
          "temperature"
          "bluetooth"
          "network"
          "pulseaudio"
          "hyprland/language"
          "battery"
          "group/group-power"
        ];

        "hyprland/workspaces" = {
          "on-click" = "activate";
          "show-special" = true;
          "sort-by" = "number";
        };

        "hyprland/window" = {
          format = "{title}";
        };

        clock = {
          format = "{:%a %d %b  %H:%M}";
          # tooltip = false;
          locale = "pt_BR.UTF-8";
          timezone = "America/Sao_Paulo";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
          };
          # format-alt = "{:%Y-%m-%d  %H:%M:%S %p}";
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = " ";
            none = " ";
            dnd-notification = " ";
            dnd-none = " ";
            inhibited-notification = " ";
            inhibited-none = " ";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = " ";
          };

          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click-right = "swaync-client -d -sw";
          on-click = "sleep 0.1; swaync-client -t -sw";
          escape = true;
        };

        tray = {
          icon-size = 14;
          spacing = 8;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = " ";
            deactivated = " ";
          };
        };

        memory = {
          interval = 30;
          format = "  {}%";
        };

        cpu = {
          format = "  {}%";
        };

        temperature = {
          format = " {temperatureC}°C";
          # format-critical = "{temperatureC}°C ";
        };

        network = {
          format = "";
          format-wifi = " ";
          format-ethernet = "󰈀 ";
          format-disconnected = "";
          tooltip-format = "{ifname} via {gwaddr} 󰊗 ";
          tooltip-format-wifi = "{essid} ({signalStrength}%)  ";
          tooltip-format-ethernet = "{ifname}  ";
          tooltip-format-disconnected = "Desconectado";
        };

        bluetooth = {
          format = " {num_connections}";
          format-disabled = "󰂲";
          tooltip-format-connected = "{device_enumerate}\n";
          tooltip-format-enumerate-connected = "{device_alias} {device_battery_percentage}%";
        };

        "hyprland/language" = {
          on-click = "hyprctl switchxkblayout at-translated-set-2-keyboard next";
          format = "{shortDescription}";
        };

        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = "  {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };

          ignored-sinks = [
            "Easy Effects Sink"
            "Easy Effects"
            "easyeffects_sink"
          ];
          on-click = "pavucontrol";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };

          format = "{capacity}% {icon}";
          format-alt = "{time} {icon}";
          format-icons = {
            default = [
              "󰂎"
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
            charging = [
              "󰢟"
              "󰢜"
              "󰂆"
              "󰂇"
              "󰂈"
              "󰢝"
              "󰂉"
              "󰢞"
              "󰂊"
              "󰂋"
              "󰂅"
            ];
          };
        };

        # "custom/power" = {
        #   format = "⏻ ";
        #   tooltip = false;
        #   on-click = "wlogout --protocol layer-shell";
        # };

        "group/group-tray" = {
          "orientation" = "inherit";
          "drawer" = {
            "click-to-reveal" = true;
            "transition-duration" = 500;
            "children-class" = "not-tray";
            "transition-left-to-right" = false;
          };

          modules = [
            "custom/expand-tray"
            "tray"
          ];
        };

        "custom/expand-tray" = {
          format = "{icon}";
          "format-icons" = {
            "default" = "";
          };
        };

        "group/group-power" = {
          "orientation" = "inherit";
          "drawer" = {
            "transition-duration" = 500;
            "children-class" = "not-power";
            "transition-left-to-right" = false;
          };
          modules = [
            "custom/power" # First element is the "group leader" and won't ever be hidden
            "custom/quit"
            "custom/lock"
            "custom/reboot"
          ];
        };

        "custom/quit" = {
          format = "󰗼";
          tooltip = false;
          "on-click" = "hyprctl dispatch exit";
        };

        "custom/lock" = {
          format = "󰍁";
          tooltip = false;
          "on-click" = "hyprlock";
        };

        "custom/reboot" = {
          format = "󰜉";
          tooltip = false;
          "on-click" = "reboot";
        };

        "custom/power" = {
          format = "";
          tooltip = false;
          "on-click" = "shutdown now";
        };
      }
    ];

    style =
      let
        inherit (nix-colors.lib.conversions) hexToRGBString;
        inherit (config.colorscheme) palette;
        toRGBA = color: opacity: "rgba(${hexToRGBString "," (lib.removePrefix "#" color)},${opacity})";
      in
      /* CSS */ ''
        * {
            min-height: 0;
            font-family: 'JetBrainsMono Nerd Font';
            font-weight: 800;
        }

        window#waybar {
            /*background: linear-gradient(0deg, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 0.80) 100%);*/
            background: ${toRGBA palette.base01 "0.95"}; 
            box-shadow: 0 0 4px #11111b;
            border-radius: 10px;
            margin: 6px;
            padding: 4px;
            color: #ffffff;
            transition-property: background-color;
            transition-duration: .5s;
        }

        window#waybar.hidden {
            opacity: 0.2;
        }

        #workspaces {
            margin-left: 5px;
        }

        #workspaces button {
            border: none;
            color: rgba(255, 255, 255, 0.6);
            padding: 0;
            margin-left: 4px;
            background: transparent;
            box-shadow: none;
        }

        #workspaces button.urgent {
            color: #fa9f8e;
        }

        #workspaces button.active,
        #workspaces button.focused {
            color: rgba(255, 255, 255, 1);
        }

        #window {
            font-weight: 400;
        }

        #pulseaudio {
            padding-right: 2px;
        }

        #pulseaudio.muted {
            color: #90b1b1;
        }

        #battery.charging,
        #battery.plugged {
            color: #2daf7b;
            background: transparent;
        }

        @keyframes blink {
            to {
                color: #f53c3c;
            }
        }

        #battery.critical:not(.charging) {
            color: #ffffff;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        #group-power {
          margin-right: 10px;
        }

        #custom-expand-tray,
        #custom-power, 
        #custom-lock, 
        #custom-reboot, 
        #custom-quit {
          padding: 0px 10px;
        }

      '';
  };
}
