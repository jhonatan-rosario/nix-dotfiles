{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations";
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git

      sops
      ssh-to-age
      gnupg
      age
    ];
  };

  mobile =
    let
      pkgs' =
        if (pkgs.config.android_sdk.accept_license or false) && (pkgs.config.allowUnfree or false) then
          pkgs
        else
          import pkgs.path {
            inherit (pkgs) system;
            config = pkgs.config // {
              allowUnfree = true;
              android_sdk.accept_license = true;
            };
          };

      androidComposition = pkgs'.androidenv.composeAndroidPackages {
        includeNDK = true;
        includeCmake = true;
        platformVersions = [
          "33"
          "34"
          "35"
          "36"
        ];
        systemImageTypes = [
          "google_apis"
          "google_apis_playstore"
        ];
        abiVersions = [
          "x86_64"
          "arm64-v8a"
          "armeabi-v7a"
        ];
        ndkVersions = [
          "26.1.10909125"
          "27.1.12297006"
        ];
        buildToolsVersions = [
          "30.0.3"
          "33.0.2"
          "34.0.0"
          "35.0.0"
          "36.0.0"
        ];
        cmakeVersions = [
          "3.22.1"
        ];
        includeExtras = [
          "extras;google;auto"
          "extras;google;m2repository"
          "extras;android;m2repository"
        ];
      };
      androidSdk = androidComposition.androidsdk;
    in
    pkgs'.mkShell {
      ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
      ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
      JAVA_HOME = "${pkgs'.jdk17}";
      CHROME_EXECUTABLE = "${pkgs'.google-chrome}/bin/google-chrome";
      GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMaven=true";

      buildInputs = with pkgs'; [
        pkg-config
        jdk17
        androidSdk
        flutter
        nodejs_24
        python314
        watchman
        cmake
        ninja
        google-chrome

        # UI & Graphics dependencies for Flutter & Android tools
        gtk3
        glib
        cairo
        pango
        atk
        gdk-pixbuf
        libX11
        libXcursor
        libXrandr
        libXi
        libGL
        zlib
      ];

      shellHook = ''
        export PATH="${androidSdk}/libexec/android-sdk/emulator:${androidSdk}/libexec/android-sdk/platform-tools:${androidSdk}/libexec/android-sdk/tools:${androidSdk}/libexec/android-sdk/tools/bin:${androidSdk}/libexec/android-sdk/cmdline-tools/latest/bin:${pkgs'.jdk17}/bin:$PATH"
        export LD_LIBRARY_PATH="${pkgs'.lib.makeLibraryPath [ pkgs'.libGL pkgs'.glib pkgs'.gtk3 pkgs'.libX11 pkgs'.libXcursor pkgs'.libXrandr pkgs'.libXi pkgs'.zlib ]}:$LD_LIBRARY_PATH"

        # Ensure child applications (like Zed or IDEs) use Fish instead of Nix's internal Bash
        if command -v fish >/dev/null 2>&1; then
          export SHELL="$(command -v fish)"
        fi

        # Auto-accept Android SDK licenses in ~/.android/licenses for AGP and Flutter
        mkdir -p "$HOME/.android/licenses"
        if [ -d "${androidSdk}/libexec/android-sdk/licenses" ]; then
          cp -rf "${androidSdk}/libexec/android-sdk/licenses"/* "$HOME/.android/licenses/" 2>/dev/null || true
        fi

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

        echo "🚀 Mobile development shell active!"
        echo "Android SDK: $ANDROID_HOME"
        echo "JAVA_HOME:   $JAVA_HOME"
      '';
    };
}
