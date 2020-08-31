[
  (self: super: with super; {
    stable = import (fetchTarball http://nixos.org/channels/nixos-20.03/nixexprs.tar.xz) {};
  })

  (import (builtins.fetchTarball https://github.com/nix-community/emacs-overlay/archive/master.tar.gz))
  (import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz))
  (import (builtins.fetchTarball https://github.com/nubank/nixpkgs/archive/master.tar.gz))
]
