{
  pkgs,
  ...
}:
{

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Para executar o winbox
      libxkbcommon
      libxcb
      libxcb-wm
      libxcb-image
      libxcb-keysyms
      libxcb-render-util
      libx11
      libglvnd
      freetype
      fontconfig
      zlib
      glibc
      dbus
    ];
  };
}
