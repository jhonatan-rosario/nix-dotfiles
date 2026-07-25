{
  pkgs,
  inputs,
  ...
}:
let
  claude-code = inputs.claude-code.packages.${pkgs.system}.default;
  codex-cli = inputs.codex-cli.packages.${pkgs.system}.default;
in
{
  imports = [
    ./mobile.nix
  ];

  home.persistence."/persist" = {
    directories = [
      ".claude"
      ".codex"
    ];
    files = [
      ".claude.json"
    ];
  };

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
    codex-cli
  ];

}
