{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    master.url = "github:NixOS/nixpkgs/master";
    hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-stable = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "stable";
    };
    flake-utils.url = "github:numtide/flake-utils";

    emacs = {
      url = "github:nix-community/emacs-overlay/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nubank.url = "github:nubank/nixpkgs/master";
    vpn = {
      url = "github:yuezk/GlobalProtect-openconnect/v2.3.8";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.greg = home-manager.lib.homeManagerConfiguration {
        modules = [ ./hosts/dell-precision ];

        inherit pkgs;
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
        gregnix-personal = mkSystem { modules = [ ./hosts/asus-zenbook-oled ]; };

        gregnix-work = mkSystem { modules = [ ./hosts/asus-zenbook-deluxe ]; };
      };
  };
}
