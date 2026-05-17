{
  programs.openvpn3 = {
    enable = true;
  };

  environment.persistence."/persist" = {
    directories = [
      "/etc/openvpn3/configs"
    ];
  };
}
