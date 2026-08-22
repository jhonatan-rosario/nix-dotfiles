{
  ...
}:
{
  programs.atuin = {
    enable = true;
    daemon.enable = true;
    forceOverwriteSettings = true;
    enableFishIntegration = true;

    settings = {
      auto_sync = true;
      sync_frequency = "10m";
      sync_address = "https://atuin.nohalls.com";
      search_mode = "fuzzy";
      filter_mode = "host";
    };
  };

  home.persistence."/persist" = {
    directories = [
      ".local/share/atuin"
    ];
  };
}
