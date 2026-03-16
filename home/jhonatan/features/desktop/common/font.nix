{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.fira-code
    inter-nerdfont
    fira
    # (google-fonts.override {fonts = ["Georama"];})
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = ["Inter Nerd Font"];
      monospace = ["FiraCode Nerd Font"];
    };
  };

  fontProfiles = {
    enable = true;
    monospace = {
      name = "FiraCode Nerd Font";
      package = pkgs.nerd-fonts.fira-code;
    };
    regular = {
      name = "Fira Sans";
      package = pkgs.fira;
    };
  };
}
