{
  ...
}:
{
  programs.rclone = {
    enable = true;
  };

  home.persistence."/persist" = {
    directories = [
      ".config/rclone"
    ];
  };
}
