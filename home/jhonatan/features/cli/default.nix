{ pkgs, ... }:
{
  imports = [
    ./ssh.nix
    ./fish.nix
    ./nh.nix
    ./git.nix
    ./distrobox.nix
    ./rclone.nix
    ./micro.nix
    ./helix.nix
    ./zoxide.nix
    ./fzf.nix
    # ./nix-alien.nix
    # ./direnv.nix
    # ./gh.nix
    # ./gpg.nix
    # ./jujutsu.nix
    # ./lyrics.nix
    # ./carapace.nix
    # ./nix-index.nix
    # ./pfetch.nix
    # ./xpo.nix
    # ./jira.nix
  ];
  home.packages = with pkgs; [
    comma # Install and run programs by sticking a , before them
    #distrobox # Nice escape hatch, integrates docker images with my environment

    wget # Download files from the internet

    bc # Calculator
    bottom # System viewer
    ncdu # TUI disk usage
    eza # Better ls
    ripgrep # Better grep
    fd # Better find
    httpie # Better curl
    diffsitter # Better diff
    bat # Better cat
    btop # Better htop
    jq # JSON pretty printer and manipulator
    # trekscii # Cute startrek cli printerc
    timer # To help with my ADHD paralysis

    nixd # Nix LSP
    alejandra # Nix formatter
    nixfmt # Nix formatter
    nvd # Differ
    nix-diff # Differ, more detailed
    nix-output-monitor
    zip
    unzip

    fastfetch
    bitwarden-cli

    wf-recorder # screen record
    cmatrix # Matrix rain
  ];
}
