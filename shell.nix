{pkgs ? import <nixpkgs> {}, ...}: let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    buildToolsVersions = [ "30.0.3" "35.0.0"];
    platformVersions = ["34" "33" "31" "30" "28"];
    abiVersions = ["x86_64" "x86"];
    includeSystemImages = true;
    systemImageTypes = ["google_apis_playstore"];
    includeEmulator = true;
    emulatorVersion = "35.2.5";
    includeExtras = [
      "extras;google;gcm"
    ];
  };

  emulator = pkgs.androidenv.emulateApp {
    name = "Android-14";
    platformVersion = "34";
    abiVersion = "x86_64";
    systemImageType = "google_apis_playstore";
  };

  androidSdk = androidComposition.androidsdk;

  # NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations";
  # FLUTTER_ROOT = "${pkgs.flutter}";
  # ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
  # ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
  # ANDROID_USER_HOME = "/home/jhonatan/.android";
  # JAVA_HOME = "${pkgs.jdk17}/lib/openjdk";

in {
  flutter327 = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations";
    FLUTTER_ROOT = "${pkgs.flutter327}";
    ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
    ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
    ANDROID_USER_HOME = "/home/jhonatan/.android";
    JAVA_HOME = "${pkgs.jdk17}/lib/openjdk";
    buildInputs = with pkgs; [
      flutter327
      jdk17
      androidSdk # The customized SDK that we've made above
      emulator
    ];
    shellHook = ''
      echo "Flutter mais atual (3.27)"
    '';
  };
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations";
    FLUTTER_ROOT = "${pkgs.flutter}";
    ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
    ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
    ANDROID_USER_HOME = "/home/jhonatan/.android";
    JAVA_HOME = "${pkgs.jdk17}/lib/openjdk";
    buildInputs = with pkgs; [
      flutter
      jdk17
      androidSdk # The customized SDK that we've made above
      emulator
    ];
    shellHook = ''
      echo "Flutter 3.24!"
    '';
  };
}
