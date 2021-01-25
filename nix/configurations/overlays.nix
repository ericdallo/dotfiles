[
  (self: super: with super; {
    stable = import (fetchTarball http://nixos.org/channels/nixos-20.09/nixexprs.tar.xz) {};
    master = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz) {};
    omnisharp = import (fetchTarball https://github.com/ericdallo/nixpkgs/archive/update-msbuild.tar.gz) {};
  })

  (import (fetchGit {
    url = "https://github.com/nix-community/emacs-overlay";
    ref = "master";
    rev = "e3da699893c4be3b946d3586143b03450f9680ee";
  }))
  # (import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz))
  (import (builtins.fetchTarball https://github.com/nubank/nixpkgs/archive/master.tar.gz))
]
