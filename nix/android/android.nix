with import <nixpkgs> {

  config = {
    android_sdk.accept_license = true;
  };
};

androidenv.emulateApp {
  name = "nix-android";
  platformVersion = "28";
  enableGPU = true;
  abiVersion = "x86";
  avdHomeDir = "$HOME";
}
