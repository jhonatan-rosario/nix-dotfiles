{ config, ... }:
{

  sops.secrets.wireless-env = { };
  # Enable networking
  networking.networkmanager = {
    enable = true;
    # unmanaged = [ "wlp0s20f3" ];
    ensureProfiles = {
      environmentFiles = [ config.sops.secrets.wireless-env.path ];
      profiles = {
        CLARO_2DFE61_5G = {
          connection = {
            id = "CLARO_2DFE61_5G";
            interface-name = "wlp2s0";
            type = "wifi";
            uuid = "7ab65817-7bc8-4a3e-9ebb-4c8ea2977548";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = { };
          wifi = {
            mode = "infrastructure";
            ssid = "CLARO_2DFE61_5G";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$HOME_WIFI_PASSWORD";
          };
        };
        CLARO_2DFE61 = {
          connection = {
            id = "CLARO_2DFE61";
            interface-name = "wlp2s0";
            type = "wifi";
            uuid = "7ab65817-7bc8-4a3e-9ebb-4c8ea2977548";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = { };
          wifi = {
            mode = "infrastructure";
            ssid = "CLARO_2DFE61";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$HOME_WIFI_PASSWORD";
          };
        };
        "UNIVALE - TI" = {
          connection = {
            id = "UNIVALE - TI";
            interface-name = "wlp2s0";
            type = "wifi";
            uuid = "cf09a480-7621-4605-a0a1-2fa89d12cf8e";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = { };
          wifi = {
            mode = "infrastructure";
            ssid = "UNIVALE - TI";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$WORK_WIFI_PASSWORD";
          };
        };
        "UNIVALE - TI - 5G" = {
          connection = {
            id = "UNIVALE - TI - 5G";
            interface-name = "wlp2s0";
            type = "wifi";
            uuid = "94aa6f85-7fe0-4101-82c7-18b18a2ec03e";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = { };
          wifi = {
            mode = "infrastructure";
            ssid = "UNIVALE - TI - 5G";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$WORK_WIFI_PASSWORD";
          };
        };
        "Z Fold7 de Jhonatan" = {
          connection = {
            id = "Z Fold7 de Jhonatan";
            interface-name = "wlp2s0";
            type = "wifi";
            uuid = "f3b66191-2f3c-494d-b7b1-310485101e03";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = { };
          wifi = {
            mode = "infrastructure";
            ssid = "Z Fold7 de Jhonatan";
          };
          wifi-security = {
            key-mgmt = "sae";
            psk = "$MY_PHONE_WIFI_PASSWORD";
          };
        };
      };
    };
  };
}
