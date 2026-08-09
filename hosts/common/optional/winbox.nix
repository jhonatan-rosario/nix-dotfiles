{ pkgs, ... }:
{
  programs.winbox = {
    enable = true;
    openFirewall = true;
  };

  security.wrappers.winbox = {
    owner = "root";
    group = "root";
    capabilities = "cap_net_raw,cap_net_admin+eip";
    source = "${pkgs.winbox}/bin/WinBox"; # Use pkgs.winbox4 se estiver usando o Winbox 4
  };
}
