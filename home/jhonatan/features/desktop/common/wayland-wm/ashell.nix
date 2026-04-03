{ ... }:
{
  programs.ashell = {
    enable = true;
    systemd.enable = true;
    settings = {
      log_level = "ashell=debug";

      position = "Top";
      layer = "Top";

      modules = {

        left = [
          "Workspaces"
          "WindowTitle"
        ];

        center = [
          "MediaPlayer"
        ];

        right = [
          "Teste"
          "SystemInfo"
          # "Tray"
          # "Tempo"
          "clock"
          # "KeyboardLayout"
          "Privacy"
          "Settings"
        ];
      };

      window_title = {
        mode = "Title";
        truncate_title_after_length = 50;
      };

      tempo = {
        # clock_format = "%d/%m/%Y %H:%M:%S";
        clock_format = "%a %d %b %R";
        # weather_location = "Current";
        # weather_indicator = "IconAndTemperature";
      };

      workspaces = {
        visibility_mode = "MonitorSpecific";
        group_by_monitor = false;
        enable_workspace_filling = true;
        max_workspaces = 9;
      };

      appearance = {
        style = "Solid";
        font = "FiraCode Nerd Font";
      };

      settings = {
        battery_format = "IconAndPercentage";
      };

      CustomModule = [
        {
          name = "Teste";
          type = "Text";
          command = "echo 'Hello World'";
        }
      ];
    };
  };
}
