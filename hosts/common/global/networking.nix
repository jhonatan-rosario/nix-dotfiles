{ config, ... }:
{

  sops.secrets.wireless-env = { };
  # Enable networking
  networking.networkmanager = {
    enable = true;
    # unmanaged = [ "wlp0s20f3" ];
    # ensureProfiles = {
    #   environmentFiles = [ config.sops.secrets.wireless-env.path ];
    #   profiles = {
    #     home-wifi = {
    #       connection = {
    #         id = "home-wifi";
    #         permissions = "";
    #         type = "wifi";
    #         autoconnect = true;
    #       };

    #       wifi = {
    #         ssid = "CLARO_2DFE61";
    #         mode = "infrastructure";
    #       };

    #       wifi-security = {
    #         key-mgmt = "wpa-psk";
    #         psk = "$HOME_WIFI_PASSWORD";
    #       };
    #     };

    #     home-wifi-5g = {
    #       connection = {
    #         id = "home-wifi-5g";
    #         permissions = "";
    #         type = "wifi";
    #         autoconnect = true;
    #       };

    #       wifi = {
    #         ssid = "CLARO_2DFE61_5G";
    #         mode = "infrastructure";
    #       };

    #       wifi-security = {
    #         key-mgmt = "wpa-psk";
    #         psk = "$HOME_WIFI_PASSWORD";
    #       };
    #     };

    #     work-wifi = {
    #       connection = {
    #         id = "work-wifi";
    #         permissions = "";
    #         type = "wifi";
    #         autoconnect = true;
    #       };

    #       wifi = {
    #         ssid = "UNIVALE - TI";
    #         mode = "infrastructure";
    #       };

    #       wifi-security = {
    #         key-mgmt = "wpa-psk";
    #         psk = "$WORK_WIFI_PASSWORD";
    #       };
    #     };

    #     work-wifi-5g = {
    #       connection = {
    #         id = "work-wifi-5g";
    #         permissions = "";
    #         type = "wifi";
    #         autoconnect = true;
    #       };

    #       wifi = {
    #         ssid = "UNIVALE - TI - 5G";
    #         mode = "infrastructure";
    #       };

    #       wifi-security = {
    #         key-mgmt = "wpa-psk";
    #         psk = "$WORK_WIFI_PASSWORD";
    #       };
    #     };
    #   };
    # };
  };

  environment.persistence."/persist".directories = [ "/etc/NetworkManager/system-connections" ];

}
