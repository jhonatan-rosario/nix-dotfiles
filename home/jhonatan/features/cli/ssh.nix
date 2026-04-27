{ ... }:
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com-work
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_ed25519
    '';
  };
}
