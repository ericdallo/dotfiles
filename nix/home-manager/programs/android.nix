{ config, lib, pkgs, ... }:

let
  # android = pkgs.androidenv.composeAndroidPackages {
  #   toolsVersion = "26.1.1";
  #   platformVersions = [ "28" ];
  #   abiVersions = [ "x86" "x86_64" ];
  #   includeEmulator = true;
  #   includeSystemImages = true;
  #   useGoogleAPIs = true;
  #   includeSources = true;
  # };

  # android-sdk-path = "${android.androidsdk}/libexec/android-sdk";

in {

  home.packages = with pkgs;
    [
      android-studio
      # android.androidsdk
    ];

  # environment.variables = {
  #   ANDROID_SDK_ROOT = android-sdk-path;
  #   ANDROID_HOME = android-sdk-path;
  # };
}
