{pkgs, ...}: {
  services.samba = {
    enable = true;
    package = pkgs.sambaFull;
    openFirewall = true;
  };
  environment.systemPackages = [pkgs.cifs-utils];
}
