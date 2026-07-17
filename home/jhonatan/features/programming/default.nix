{
  pkgs,
  inputs,
  ...
}:
let
  claude-code = inputs.nix-claude-code.packages.x86_64-linux.default;
in
{
  imports = [
    ./android.nix
  ];

  home.persistence."/persist".directories = [
    ".claude"
  ];

  programs = {
    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };
  };

  home.packages = with pkgs; [
    bun
    nodejs_24
    claude-code
  ];

}
