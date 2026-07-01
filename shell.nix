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
      # pkgs = pkgs.overrideAttrs (oldAttrs: {
      #   config.allowUnfree = true;
      #   config.android_sdk.accept_license = true;
      # });
      androidComposition = pkgs.androidenv.composeAndroidPackages {
        includeNDK = true;
        includeCmake = true;
        platformVersions = [
          "35"
          "36"
          "latest"
        ];
        systemImageTypes = [ "google_apis_playstore" ];
        abiVersions = [
          "armeabi-v7a"
          "arm64-v8a"
        ];
        ndkVersions = [
          "27.1.12297006"
        ];
        buildToolsVersions = [
          "35.0.0"
          "36.0.0"
        ];
        cmakeVersions = [
          "3.22.1"
        ];
        includeExtras = [ "extras;google;auto" ];
      };
      androidSdk = androidComposition.androidsdk;
    in
    pkgs.mkShell {
      ANDROID_HOME = "${androidSdk}/libexec/android-sdk";

      buildInputs = with pkgs; [
        pkg-config
        jdk17
        androidSdk
        flutter
        nodejs_24
        python314
        watchman
      ];

      shellHook = ''
        export PATH=$PATH:${androidSdk}/libexec/android-sdk/platform-tools:${androidSdk}/libexec/android-sdk/tools
        echo "Starting mobile shell..."
        echo "Android SDK at: $ANDROID_HOME"
        echo "JDK at: $JAVA_HOME"
      '';
    };
}
