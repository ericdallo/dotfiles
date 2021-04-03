{ stdenv, fetchFromGitHub, pkgs, ... }:

let
  android = pkgs.androidenv.composeAndroidPackages {
    toolsVersion = "26.1.1";
    platformVersions = [ "28" ];
    abiVersions = [ "x86" "x86_64"];
    includeEmulator = true;
    includeSystemImages = true;
    useGoogleAPIs = true;
    includeSources = true;
  };

  android-sdk-path = "${android.androidsdk}/libexec/android-sdk";

  emacsPackage = ((pkgs.emacsPackagesGen pkgs.emacsGcc).emacsWithPackages (epkgs: [
        epkgs.vterm
      ]));

in {
  nixpkgs.config.android_sdk.accept_license = true;
 
  environment.systemPackages = with pkgs;
   
  let
    custom-python-packages = python-packages: with python-packages; [
      # pandas
      # jupyter
      # matplotlib
      # virtualenvwrapper
      python-language-server
      pybluez
      # bluepy
      # seaborn
      # pillow
      fonttools
      pip
    ];
    python-with-my-packages = stable.python37Full; #.withPackages custom-python-packages;
    vcsodeWithExtension = master.vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        bbenoist.Nix
        python
      ]
      # Concise version from the vscode market place when not available in the default set.
      ++ vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "code-runner";
          publisher = "formulahendry";
          version = "0.6.33";
          sha256 = "166ia73vrcl5c9hm4q1a73qdn56m0jc7flfsk5p5q41na9f10lb0";
        }
        {
          name = "dart-code";
          publisher = "dart-code";
          version = "3.14.0";
          sha256 = "1qvnbyrk73z5vbqkm35awiih14bccawrmgq3y2ykh3fabccn1lal";
        }
        {
          name = "flutter";
          publisher = "dart-code";
          version = "3.14.0";
          sha256 = "12dxbw5s1y8kxzf53a4qr6ismb0s35ah4imba7s8l90bhfizaai3";
        }
        {
          name = "debugger-for-chrome";
          publisher = "msjsdiag";
          version = "4.12.6";
          sha256 = "1dlplz72830shqbi7zkgg7pb45ijwajwhkmapx4lmlw13z41jw1g";
        }
        {
          name = "js-debug-nightly";
          publisher = "ms-vscode";
          version = "2020.5.1217";
          sha256 = "18ysb0f7rind40xh4qhrrjkxkibhzh6sp9xvdfycpn9j1mgmywv8";
        }
        {
          name = "csharp";
          publisher = "ms-dotnettools";
          version = "1.23.2";
          sha256 = "0ydaiy8jfd1bj50bqiaz5wbl7r6qwmbz9b29bydimq0rdjgapaar";
        }
      ]
      # ++ [
      #   (pkgs.vscode-utils.buildVscodeExtension {
      #     name = "calva-test";
      #     vscodeExtUniqueId = "pez.calva";
      #     src = pkgs.fetchurl {
      #       name = "calva-2.0.135-feat-lsp-client-3166a539.zip";
      #       url = "https://9023-125431277-gh.circle-artifacts.com/0/tmp/artifacts/calva-2.0.135-feat-lsp-client-3166a539.vsix";
      #       sha256 = "0vby8i05qqf3rbbsnzmqyx2hb53x3gv4a5k66v0jcadw2l5s4i1v";
      #     };
      #   })
      # ]
      ;
    };

  in
    [
      android-studio
      android.androidsdk
      stable.awscli
      clojure
      clojure-lsp
      docker-compose
      emacsPackage
      nubank.dart
      nubank.flutter
      nubank.hover
      gitAndTools.hub
      go
      # clj-kondo
      master.babashka
      (leiningen.override { jdk = jdk11; })
      nodejs-10_x
      python-with-my-packages
      shellcheck
      vcsodeWithExtension
    ];

  environment.variables = {
    ANDROID_SDK_ROOT = android-sdk-path;
    ANDROID_HOME = android-sdk-path;
  };

  programs = {
    java = {
      enable = true;
      package = pkgs.jdk11;
    };

    adb.enable = true;
  };

  services.emacs = with pkgs; {
    enable = true;
    defaultEditor = true;
    package = emacsPackage;
  };

  users.users.greg.extraGroups = [ "docker" "vboxusers" ];

}
