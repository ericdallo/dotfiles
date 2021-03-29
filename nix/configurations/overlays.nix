[
  (self: super: with super; {
    stable = import (fetchTarball http://nixos.org/channels/nixos-20.09/nixexprs.tar.xz) {};
    master = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz) {};
  })

  (import (fetchGit {
    url = "https://github.com/nix-community/emacs-overlay";
    ref = "master";
    rev = "bb9fb65a68e18b4e136a0355155a0d03ce651729";
  }))
  # (import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz))
  (import (builtins.fetchTarball https://github.com/nubank/nixpkgs/archive/master.tar.gz))
]
