{ pkgs, lib, self, system, ... }:

let
  inherit (self) inputs;
in {
  nixpkgs.overlays = [
    inputs.emacs.overlay

    (final: prev: {
      stable = import inputs.stable {
        inherit system;
        config = prev.config;
      };

      master = import inputs.master {
        inherit system;
        config = prev.config;
      };

      nubank = import inputs.nubank {
        inherit system;
        config = prev.config;
      };

      # Provide compatibility for packages expecting unversioned 'webkitgtk'
      # Nixpkgs removed 'webkitgtk' alias; use a specific ABI version.
      webkitgtk = prev.webkitgtk_4_1;

      vpn = inputs.vpn.packages.${system}.default;
    })
  ];
}
