{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-21.05";
    master.url = "github:NixOS/nixpkgs/master";
    hardware.url = "github:NixOS/nixos-hardware/master";
    home = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-stable = {
      url = "github:nix-community/home-manager/release-21.05";
      inputs.nixpkgs.follows = "stable";
    };
    flake-utils.url = "github:numtide/flake-utils";

    emacs = {
      url = "github:nix-community/emacs-overlay/master";
      inputs.nixpkgs.follows = "unstable";
    };
    nubank.url = "github:nubank/nixpkgs/master";
  };

  outputs = { self, nixpkgs, home, flake-utils, ... }: {
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
