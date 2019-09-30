{ stdenv, fetchFromGitHub, pkgs, ... }:

{

  environment.systemPackages = with pkgs;
  let
    vcsodeWithExtension = vscode-with-extensions.override {
      # When the extension is already available in the default extensions set.
      vscodeExtensions = with vscode-extensions; [
        bbenoist.Nix
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
  in
    [
      clojure
      docker-compose
      awscli
      joker
      leiningen
      vcsodeWithExtension
      gitAndTools.hub
      (eclipses.eclipseWithPlugins {
        eclipse = eclipses.eclipse-java;
        jvmArgs = [ "-Xms6000m" "-Xmx8096m" ];
        plugins = with eclipses.plugins;
          [ gradle ];
      })
      android-studio
    ];

  # Java
  programs.java = {
    enable = true;
    package = pkgs.jdk8;
  };

  virtualisation = {
    # Enable Docker.
    docker.enable = true;

    # Enable VirtualBox.
    # virtualbox.host.enable = true;
  };

  users.users.greg.extraGroups = [ "docker" "vboxusers" ];

}
