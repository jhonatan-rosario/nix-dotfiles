{ pkgs, ... }:
{
  home.packages = with pkgs; [
    file-roller
    p7zip
    unrar
    unzip
    zip
  ];

  xdg.mimeApps = {
    associations.added = {
      "inode/directory" = "thunar.desktop";
      "application/zip" = "org.gnome.FileRoller.desktop";
      "application/x-zip-compressed" = "org.gnome.FileRoller.desktop";
      "application/x-tar" = "org.gnome.FileRoller.desktop";
      "application/x-compressed-tar" = "org.gnome.FileRoller.desktop";
      "application/x-bzip-compressed-tar" = "org.gnome.FileRoller.desktop";
      "application/x-xz-compressed-tar" = "org.gnome.FileRoller.desktop";
      "application/x-zstd-compressed-tar" = "org.gnome.FileRoller.desktop";
      "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
      "application/x-7z-compressed-tar" = "org.gnome.FileRoller.desktop";
      "application/vnd.rar" = "org.gnome.FileRoller.desktop";
      "application/x-rar" = "org.gnome.FileRoller.desktop";
      "application/x-rar-compressed" = "org.gnome.FileRoller.desktop";
      "application/gzip" = "org.gnome.FileRoller.desktop";
      "application/x-bzip" = "org.gnome.FileRoller.desktop";
      "application/x-bzip2" = "org.gnome.FileRoller.desktop";
      "application/x-xz" = "org.gnome.FileRoller.desktop";
      "application/x-zstd" = "org.gnome.FileRoller.desktop";
    };
    defaultApplications = {
      "inode/directory" = [ "thunar.desktop" ];
      "application/zip" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-zip-compressed" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-bzip-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-xz-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-zstd-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-7z-compressed" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-7z-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
      "application/vnd.rar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-rar" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-rar-compressed" = [ "org.gnome.FileRoller.desktop" ];
      "application/gzip" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-bzip" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-bzip2" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-xz" = [ "org.gnome.FileRoller.desktop" ];
      "application/x-zstd" = [ "org.gnome.FileRoller.desktop" ];
    };
  };
}
