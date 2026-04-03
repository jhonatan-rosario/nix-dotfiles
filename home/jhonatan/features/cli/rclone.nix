{
  ...
}:
{
  programs.rclone = {
    enable = true;
    remotes = {
      gdrive = {
        config = {
          type = "drive";
          scope = "drive";
        };

        secrets = {

        };
      };
    };
  };
}
