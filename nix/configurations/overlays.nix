[
  (self: super: with super; {
    stable = import (fetchTarball http://nixos.org/channels/nixos-21.05/nixexprs.tar.xz) {};
    master = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz) {};
  })

  (import (fetchGit {
    url = "https://github.com/nix-community/emacs-overlay";
    ref = "master";
    rev = "ca18017fa61a4bb8069d1bba74c4198c3c21c6fc";
  }))
  # (import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz))
  (import (builtins.fetchTarball https://github.com/nubank/nixpkgs/archive/master.tar.gz))
]
