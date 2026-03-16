{
  ...
}:
let
  isCharging = "(($(cat /sys/class/power_supply/AC/online) == 0))";
in {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        ignore_dbus_inhibit = false;
      };

      listener = [
        # When the notebook is charging
        {
            timeout = 60; # 1min.
            on-timeout = "${isCharging} && light -O && light -S 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = "${isCharging} && light -I"; # monitor backlight restore.
        }
        # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
        { 
            timeout = 30; # 0.5min.
            on-timeout = "light -s sysfs/leds/dell::kbd_backlight -O && light -s sysfs/leds/dell::kbd_backlight -S 0"; # turn off keyboard backlight.
            on-resume = "light -s sysfs/leds/dell::kbd_backlight -I"; # turn on keyboard backlight.
        }
        {
            timeout = 300; # 5min
            on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
        }
        {
            timeout = 330; # 5.5min
            on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
            on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
        }
        {
            timeout = 600; # 10min
            # on-timeout = "${isCharging} && systemctl suspend"; # suspend if the notebook isn't plugged in
            on-timeout = "systemctl suspend"; # suspend if the notebook isn't plugged in
        }
      ];
    };
  };
}
