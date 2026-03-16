{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    gtk3
  ];

  programs.nix-ld = {
    enable = true;
    # libraries = with pkgs; [
    #   gtk3 #fix anydesk
    # ];
  };
}
