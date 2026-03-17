{
  # Nice wrapper for NixOS and HM
  programs.nh = {
    enable = true;
    flake = "$HOME/nix";
  };
}
