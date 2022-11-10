{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-22.05";
    master.url = "github:NixOS/nixpkgs/master";
    hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-stable = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "stable";
    };
    flake-utils.url = "github:numtide/flake-utils";

    emacs = {
      url = "github:ericdallo/emacs-overlay/add-emacs-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nubank.url = "github:nubank/nixpkgs/master";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.greg = home-manager.lib.homeManagerConfiguration {
        modules = [ ./home-manager/nubank-debian.nix ];

        inherit  pkgs;
        # homeDirectory = "/home/${username}";
        # stateVersion = "22.05";
        extraSpecialArgs = { inherit self system; };
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
