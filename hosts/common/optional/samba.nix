{ pkgs, config, ... }:
let
  hostname = config.networking.hostName;
in
{
  # Enable Avahi for mDNS/Bonjour service discovery.
  # Allows printing without manually typing IP addresses in clients.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      userServices = true;
    };
  };

  users.groups.samba-users = { };

  systemd.tmpfiles.rules = [
    "d /persist/shares/public 0777 nobody nogroup -"
    "d /persist/shares/private 0770 root samba-users -"
  ];

  services.samba = {
    enable = true;
    package = pkgs.samba4;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "NixOS Samba Server (${hostname})";
        "netbios name" = hostname;
        "security" = "user";
        #"use sendfile" = "yes";
        #"max protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        # "hosts allow" = "192.168.0. 172.16.0. 127.0.0.1 localhost";
        # "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "public" = {
        "path" = "/persist/shares/public";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "nobody";
        "force group" = "nogroup";
      };
      "private" = {
        "path" = "/persist/shares/private";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0660";
        "directory mask" = "0770";
        "valid users" = "@samba-users";
        "force group" = "samba-users";
      };
    };
  };
  environment.systemPackages = [ pkgs.cifs-utils ];

  environment.persistence."/persist" = {
    directories = [ "/var/lib/samba" ];
  };
}
