{ ... }:
{
  services.remmina = {
    enable = true;
  };

  home.persistence."/persist".directories = [
    ".local/share/remmina"
    ".cache/remmina"
  ];
}
