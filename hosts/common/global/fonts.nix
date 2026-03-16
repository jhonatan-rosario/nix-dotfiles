{pkgs, ...}: {
  # Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.fira-code
    # (nerdfonts.override {fonts = ["FiraCode"];})
    # nerd-font-patcher
  ];
}
