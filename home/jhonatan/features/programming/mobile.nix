{ pkgs, ... }:
let
  mobile-fhs = (
    pkgs.buildFHSEnv {
      name = "mobile-dev";
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

          google-chrome
          # Adicione outras libs que o Expo ou Flutter reclamar
        ];
      runScript = "fish"; # Ou seu shell de preferência
      profile = ''
        export ANDROID_HOME="$HOME/Android/Sdk"
        export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
        export JAVA_HOME="${pkgs.jdk17}"
        export GRADLE_USER_HOME="$HOME/.gradle"
        export CHROME_EXECUTABLE=${pkgs.google-chrome}/bin/google-chrome
        export PATH="$PATH:$JAVA_HOME/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/cmdline-tools/latest/bin:${pkgs.google-chrome}/bin"

        # Auto-accept Android SDK licenses in ~/.android/licenses for AGP and Flutter
        mkdir -p "$HOME/.android/licenses"
        cat << 'EOF' > "$HOME/.android/licenses/android-sdk-license"
89330172875f4570941119e27d38e4d2a3f49e48
24333f8a6371c6ea4d1269f73b041419af280b1d
d56f51874794514649f638c2cb5b022569f4465a
37b45408466e45f3a0937a77e8a939f50e7a1772
EOF
        cat << 'EOF' > "$HOME/.android/licenses/android-sdk-preview-license"
84831b9409646a918e30573bab4c9c91346d8abd
EOF
        cat << 'EOF' > "$HOME/.android/licenses/android-googletv-license"
601007b946f432773229b47e2a907297e685f0ef
EOF
        cat << 'EOF' > "$HOME/.android/licenses/google-gdk-license"
33b6a2b64607f11b759f320ef9dff4ae5c47d96a
EOF
        cat << 'EOF' > "$HOME/.android/licenses/intel-android-extra-license"
d975f751698a77b6298d2281331bc60f34573096
EOF

        # Customize o prompt do Fish
        exec ${pkgs.fish}/bin/fish -C '
            functions -q fish_prompt; and functions -c fish_prompt _old_fish_prompt
            function fish_prompt
              printf "\n%s%s%s\n%s[mobile]❯%s " \
                (set_color --bold $fish_color_operator) \
                (prompt_pwd) \
                (set_color --reset) \
                (set_color $fish_color_cwd) \
                (set_color --reset)
            end
          '
      '';
    }
  );
in
{
  home.packages = [
    mobile-fhs
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
