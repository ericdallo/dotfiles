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

in {
  nixpkgs.config.android_sdk.accept_license = true;
 
  environment.systemPackages = with pkgs;
   
  let
    jotform = python37.pkgs.buildPythonPackage {
      pname = "jotform";
      version = "python_3_compatibility";

      src = pkgs.fetchFromGitHub {
        owner = "atleta";
        repo = "jotform-api-python";
        rev = "082cfe7906de14d1f999cf1259a863d8e4d9da81";
        sha256 = "04kn2yp4szmzvc2viy5kyb6yj5s5l21klv2hf8d6ygfa95f7w4wx";
      };

      doCheck = false;
    };

    custom-python-packages = python-packages: with python-packages; [
      pandas
      jupyter
      matplotlib
      virtualenvwrapper
      seaborn
      pillow
      jotform
    ];
    python-with-my-packages = python3Full.withPackages custom-python-packages;
    vcsodeWithExtension = vscode-with-extensions.override {
      # When the extension is already available in the default extensions set.
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
          version = "3.9.1";
          sha256 = "02fmbrikpf1hp98w0b8qy1940ir2pjzqxb00fpv5qmrn0qgr581r";
        }
        {
          name = "flutter";
          publisher = "dart-code";
          version = "3.9.1";
          sha256 = "1lqsivqf4kmgih1wv44bvjwm2h1yxhpz7ij57d1jlf63r65xy2d3";
        }
      ];
    };

    hover = (import (fetchTarball https://github.com/ericdallo/nixpkgs/archive/hover-flutter.tar.gz) {}).hover;
  in
    [
      android-studio
      android.androidsdk
      awscli
      clojure
      clojure-lsp
      dart_dev
      docker-compose
      # (eclipses.eclipseWithPlugins {
      #   eclipse = eclipses.eclipse-java;
      #   jvmArgs = [ "-Xms6000m" "-Xmx8096m" ];
      #   plugins = with eclipses.plugins;
      #     [ gradle ];
      # })
      emacsGit
      # flutter
      gitAndTools.hub
      go
      heroku
      hover
      joker
      # clj-kondo
      leiningen
      mysql
      nodejs
      nodePackages.node2nix
      # python-with-my-packages
      rustup
      sass
      sassc
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

  users.users.greg.extraGroups = [ "docker" "vboxusers" ];

}
