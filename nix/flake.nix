{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Kernel pin: nixpkgs-unstable currently ships linux 6.18.33, whose
    # i915 driver black-screens at GDM on this UX3405MA Meteor Lake iGPU
    # (PCI 7d55). Pin the last-good rev (linux 6.18.16) and use it ONLY
    # for `boot.kernelPackages`; every other package stays on `nixpkgs`.
    # Re-point at nixpkgs-unstable (or drop this input) once the upstream
    # i915 regression is fixed.
    nixpkgs-kernel.url = "github:NixOS/nixpkgs/e38213b91d3786389a446dfce4ff5a8aaf6012f2";

    stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    master.url = "github:NixOS/nixpkgs/master";
    hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs = {
      url = "github:nix-community/emacs-overlay/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nubank is itself a nixpkgs fork and has no own inputs — `follows`
    # would be a no-op. Same for nix-flatpak.
    nubank.url = "github:nubank/nixpkgs/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # GlobalProtect VPN client (CLI build of yuezk/GlobalProtect-openconnect).
    # Personal fork hosts the Nix flake / package recipe so it can evolve
    # independently of this config (and eventually be PR'd upstream).
    gp-openconnect = {
      url = "github:ericdallo/GlobalProtect-openconnect/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Zscaler-on-Docker, kept in a separate, Nubank-shareable repo so non-Nix
    # Docker users can use it too. It exposes `nixosModules.zscaler`, which
    # configuration.nix imports.
    zscaler-docker.url = "git+ssh://git@github.com/nubank/zscaler-docker?ref=master";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.greg = home-manager.lib.homeManagerConfiguration {
        modules = [ ./hosts/asus-zenbook-oled/ubuntu.nix ];

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
        gregnix-deluxe = mkSystem { modules = [ ./hosts/asus-zenbook-deluxe ]; };
        gregnix-personal = mkSystem { modules = [ ./hosts/asus-zenbook-oled ]; };
      };
  };
}
