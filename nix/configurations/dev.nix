{ stdenv, fetchFromGitHub, pkgs, ... }:

{
  environment.systemPackages = with pkgs;

  let
    stable = import (fetchTarball http://nixos.org/channels/nixos-19.09/nixexprs.tar.xz) {};

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
      ];
    };

    nixpkgs.config.android_sdk.accept_license = true;

    flutter = (import (fetchTarball https://github.com/babariviere/nixpkgs/archive/flutter-init.tar.gz) {}).flutter;
  in
    [
      android-studio
      awscli
      clojure
      clojure-lsp
      dart
      docker-compose
      (eclipses.eclipseWithPlugins {
        eclipse = eclipses.eclipse-java;
        jvmArgs = [ "-Xms6000m" "-Xmx8096m" ];
        plugins = with eclipses.plugins;
          [ gradle ];
      })
      #flutter
      gitAndTools.hub
      heroku
      joker
      #clj-kondo
      leiningen
      mysql
      nodejs
      nodePackages.node2nix
      python-with-my-packages
      sass
      sassc
      vcsodeWithExtension
    ];

  programs = {
    java = {
      enable = true;
      package = pkgs.jdk8;
    };

    adb.enable = true;
  };

  users.users.greg.extraGroups = [ "docker" "vboxusers" ];

}
