{ pkgs, ... }:
{
  imports = [ ../common ];

  programs.plasma = {
    enable = true;

    #input.touchpads = [
    #  {
    #    name = "Virtual core XTEST pointer";
    #    naturalScrolling = true;
    #  }
    #];

    hotkeys.commands = {
      "launch-settings" = {
        name = "Launch Settings";
        key = "Meta+I";
        command = "plasma-open-settings";
      };
    };
  };
}
