{ pkgs, ... }:
let
  android-fhs = (
    pkgs.buildFHSEnv {
      name = "android-dev";
      targetPkgs =
        pkgs: with pkgs; [
          # Bibliotecas que os binários do Google (adb, aapt2, etc) exigem
          glibc
          zlib
          ncurses5
          # libstdcxx5
          stdenv.cc.cc
          libGL

          # Dependências para a interface do Flutter/Android Studio
          fontconfig
          freetype
          libX11
          libXcursor
          libXrender
          libXi
          libXext
          libXrandr
          libXtst
          at-spi2-core
          gtk3
          gdk-pixbuf
          cairo
          pango
          glib
          dbus
          libXcomposite

          # Dependências para o Expo
          nodejs_24
          watchman

          # Ferramentas que você quer que o Nix gerencie
          jdk17
          flutter
          pkg-config
          cmake
          ninja
          which

          # Adicione outras libs que o Expo ou Flutter reclamar
        ];
      runScript = "fish"; # Ou seu shell de preferência
      profile = ''
        export ANDROID_HOME="$HOME/Android/Sdk"
        export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
        export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/cmdline-tools/latest/bin"
      '';
    }
  );
in
{
  home.packages = [
    android-fhs
  ];

  home.persistence."/persist" = {
    directories = [
      "Android" # Onde o SDK e as licenças ficam
      ".android" # Onde ficam as chaves de debug e configs do emulador
      ".gradle" # Cache do Gradle (importante para build de APK)]
      ".dart-tool" # Cache do Dart
      ".pub-cache" # Cache global de pacotes do Flutter/Dart (Muito importante!)
      ".config/flutter" # Configurações do Flutt
    ];
  };
}
