{pkgs, ...}: {
  imports = [
    ./fish.nix
    ./nushell.nix
    ./micro.nix
    ./nh.nix
    ./git.nix
    # ./nix-alien.nix
    # ./bat.nix
    # ./direnv.nix
    # ./gh.nix
    # ./gpg.nix
    # ./jujutsu.nix
    # ./lyrics.nix
    # ./carapace.nix
    # ./nix-index.nix
    # ./pfetch.nix
    # ./ssh.nix
    # ./xpo.nix
    # ./fzf.nix
    # ./jira.nix
  ];
  home.packages = with pkgs; [
    comma # Install and run programs by sticking a , before them
    distrobox # Nice escape hatch, integrates docker images with my environment

    bc # Calculator
    bottom # System viewer
    ncdu # TUI disk usage
    eza # Better ls
    ripgrep # Better grep
    fd # Better find
    httpie # Better curl
    diffsitter # Better diff
    jq # JSON pretty printer and manipulator
    # trekscii # Cute startrek cli printerc
    timer # To help with my ADHD paralysis

    nixd # Nix LSP
    alejandra # Nix formatter
    nixfmt-rfc-style
    nvd # Differ
    nix-diff # Differ, more detailed
    nix-output-monitor
    zip
    unzip

    fastfetch
    bitwarden-cli

    wf-recorder # screen record
  ];
}
