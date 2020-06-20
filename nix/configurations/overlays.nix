[
  (self: super: with super; {
    stable = import (fetchTarball http://nixos.org/channels/nixos-19.09/nixexprs.tar.xz) {};
  })

  # emacsGit
  (import (builtins.fetchTarball https://github.com/nix-community/emacs-overlay/archive/master.tar.gz))
  (import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz))
]
