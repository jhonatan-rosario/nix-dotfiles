{ ... }:
{
  programs.distrobox = {
    enable = true;
    enableSystemdUnit = true;
    containers = {
      ubuntu = {
        adicional_packages = "git bun";
        entry = true;
        image = "ubuntu:24.04";
      };
    };
  };
}
