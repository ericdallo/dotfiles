{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-21.11";
    master.url = "github:NixOS/nixpkgs/master";
    hardware.url = "github:NixOS/nixos-hardware/master";
    home = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-stable = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "stable";
    };
    flake-utils.url = "github:numtide/flake-utils";

    emacs = {
      url = "github:nix-community/emacs-overlay/master";
      inputs.nixpkgs.follows = "unstable";
    };
    nubank.url = "github:nubank/nixpkgs/master";
  };

  outputs = { self, nixpkgs, home, flake-utils, ... }:
    let
      system = "x86_64-linux";
      username = "greg";
    in {
      homeConfigurations.greg = home.lib.homeManagerConfiguration {
        configuration = import ./home-manager/nubank.nix;

        inherit system username;
        homeDirectory = "/home/${username}";
        stateVersion = "21.11";
        extraSpecialArgs = { inherit self system; };

        # Optionally use extraSpecialArgs
      };

      nixosConfigurations =
      let
        mkSystem = { modules, system ? "x86_64-linux" }:
          nixpkgs.lib.nixosSystem {
            inherit system modules;
            specialArgs = { inherit self system; };
          };
      in
      {
        gregnix-personal = mkSystem { modules = [ ./hosts/asus-zenbook ]; };

        gregnix-nubank = mkSystem { modules = [ ./hosts/dell-nubank ]; };

        gregnix-ssd = mkSystem { modules = [ ./hosts/samsung-ssd ]; };
      };
  };
}
