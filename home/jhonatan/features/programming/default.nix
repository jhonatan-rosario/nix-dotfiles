{
  pkgs,
  inputs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  antigravity-cli = inputs.antigravity.packages.${system}.antigravity-cli;
  claude-code = inputs.claude-code.packages.${system}.default;
  codex-cli = inputs.codex-cli.packages.${system}.default;
  openspec = inputs.openspec.packages.${system}.default;
in
{
  imports = [
    ./mobile.nix
  ];

  home.persistence."/persist" = {
    directories = [
      ".gemini"
      ".antigravity"
      ".antigravity-ide"
      ".config/Antigravity"
      ".config/Antigravity IDE"
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
    antigravity-cli
    claude-code
    codex-cli
    orca-ide
    openspec
  ];

}
