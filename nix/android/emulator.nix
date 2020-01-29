with import <nixpkgs> {

  config = {
    android_sdk.accept_license = true;
  };
};

androidenv.emulateApp {
  name = "nix-android";
  platformVersion = "29";
  enableGPU = true;
  abiVersion = "x86";
  avdHomeDir = "$HOME";
}
