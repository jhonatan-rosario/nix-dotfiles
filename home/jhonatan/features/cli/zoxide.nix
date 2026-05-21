{ ... }:
{
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  home.persistence."/persist" = {
    directories = [
      ".local/share/zoxide"
    ];
  };
}
