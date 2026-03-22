{ pkgs, lib, self, system, ... }:

let
  inherit (self) inputs;
in {
  nixpkgs.overlays = [
    inputs.emacs.overlay

    (final: prev:
      let
        cfg = {
          allowUnfree = true;
        };
      in {
      stable = import inputs.stable {
        inherit system;
        config = cfg;
      };

      master = import inputs.master {
        inherit system;
        config = cfg;
      };

      nubank = import inputs.nubank {
        inherit system;
        config = cfg;
      };
      vpn = inputs.vpn.packages.${system}.default;
    })
  ];
}
