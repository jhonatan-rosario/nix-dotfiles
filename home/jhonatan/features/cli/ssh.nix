{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "github.com-work" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  home.persistence."/persist" = {
    directories = [
      {
        directory = ".ssh";
        mode = "0700";
      }
    ];
  };

}
