[
  (self: super: with super; {
    stable = import (fetchTarball http://nixos.org/channels/nixos-20.03/nixexprs.tar.xz) {};
    master = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz) {};
    omnisharp = import (fetchTarball https://github.com/ericdallo/nixpkgs/archive/update-msbuild.tar.gz) {};
  })

  (import (builtins.fetchTarball https://github.com/nix-community/emacs-overlay/archive/master.tar.gz))
  (import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz))
  (import (builtins.fetchTarball https://github.com/nubank/nixpkgs/archive/fix-flutter.tar.gz))
]
