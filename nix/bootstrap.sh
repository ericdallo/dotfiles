#!/usr/bin/env bash
# nix/bootstrap.sh <host>: turn a fresh NixOS install (the official ISO's
# installer, or any other way) into <host>, a nixosConfiguration of this
# flake. As your user, from a clone (git isn't in a fresh install):
#
#   nix-shell -p git --run 'git clone https://github.com/ericdallo/dotfiles ~/.dotfiles'
#   ~/.dotfiles/nix/bootstrap.sh gregnix-s14
#
# 1. writes the host's hardware-configuration.nix from what the installer
#    generated in /etc/nixos, and git-adds it (commit it afterwards)
# 2. builds the host and makes it the next boot (asks for sudo)
# Then reboot. See nix/README.md.
set -euo pipefail

die() {
  echo "error: $*" >&2
  exit 1
}
step() { printf '\n\033[1;35m==> %s\033[0m\n' "$*"; }

if [[ $# -ne 1 ]]; then
  echo "usage: nix/bootstrap.sh <host>   (e.g. gregnix-s14)" >&2
  exit 2
fi
host=$1
flake=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
etc=${BOOTSTRAP_ETC:-/etc/nixos} # overridable, to test

[[ $EUID -ne 0 ]] || die "run it as your user: it uses sudo where needed"
[[ -e /etc/NIXOS ]] || die "this isn't NixOS"
command -v git >/dev/null || exec nix-shell -p git --run "$(printf '%q ' "$0" "$@")"

dir=$(grep -oP "^\s*\Q$host\E = mkSystem \{ modules = \[ \./hosts/\K[^ \]]+" "$flake/flake.nix") ||
  die "no $host in nix/flake.nix's nixosConfigurations: add the host first (nix/README.md)"
out=$flake/hosts/$dir/hardware-configuration.nix

step "Writing hosts/$dir/hardware-configuration.nix from $etc"
[[ -f $etc/hardware-configuration.nix ]] || die "no $etc/hardware-configuration.nix: is this a fresh NixOS install?"
# The NixOS installer declares encrypted swap only in configuration.nix
# ("nixos-generate-config doesn't seem to notice them").
swap=$(grep -E '^\s*boot\.initrd\.luks\.devices\."[^"]+"\.device\s*=' "$etc/configuration.nix" 2>/dev/null || true)
names=$(printf '%s\n' "$swap" | cat "$etc/hardware-configuration.nix" - |
  grep -oP 'boot\.initrd\.luks\.devices\."\K[^"]+' | sort -u || true)
extra=$(
  if [[ -n $swap ]]; then
    echo "  # Encrypted swap: only the installer's configuration.nix declares it."
    echo "$swap"
  fi
  if [[ -n $names ]]; then
    echo "  # TRIM (services.fstrim) through LUKS, and faster on NVMe."
    for name in $names; do
      echo "  boot.initrd.luks.devices.\"$name\".allowDiscards = true;"
      echo "  boot.initrd.luks.devices.\"$name\".bypassWorkqueues = true;"
    done
  fi
)
{
  echo "# Written by nix/bootstrap.sh from the NixOS installer's $etc: its"
  echo "# hardware-configuration.nix, plus what follows its last line of options."
  echo "# Run nix/bootstrap.sh again after reinstalling."
  # Without its "Do not modify" header (it's ours now), and with the extra
  # options spliced in before the module's closing brace.
  awk -v extra="$extra" '
    !body && /^#/ { next }
    { body = 1; line[++n] = $0 }
    /^}/ { last = n }
    END {
      if (extra != "" && !last) exit 1
      for (i = 1; i <= n; i++) {
        if (i == last && extra != "") print extra
        print line[i]
      }
    }' "$etc/hardware-configuration.nix"
} >"$out" || die "couldn't add the extra options to $out"
nix-instantiate --parse "$out" >/dev/null || die "$out doesn't parse"
git -C "$flake" add "$out"

# The private zscaler-docker input needs a GitHub SSH key, which a fresh
# install doesn't have yet: a stand-in replaces it until the next rebuild.
overrides=()
url=$(grep -oP 'zscaler-docker\.url = "git\+\K[^"?]+' "$flake/flake.nix" || true)
if [[ -n $url ]] && ! GIT_SSH_COMMAND="ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10" \
  git ls-remote "$url" HEAD >/dev/null 2>&1; then
  echo "No GitHub SSH key for the private zscaler-docker input yet: building with its stand-in (nix/stubs/zscaler-docker)."
  overrides=(--override-input zscaler-docker "path:$flake/stubs/zscaler-docker" --no-write-lock-file)
fi

step "Building $host (mostly downloads from cache.nixos.org)"
nix --extra-experimental-features 'nix-command flakes' build \
  "$flake#nixosConfigurations.$host.config.system.build.toplevel" \
  --out-link "$flake/result" "${overrides[@]}"
system=$(readlink -f "$flake/result")

step "Making it the next boot"
sudo nix-env -p /nix/var/nix/profiles/system --set "$system"
sudo "$system/bin/switch-to-configuration" boot

step "Done: reboot"
echo "Then copy ~/.ssh and ~/.gnupg from another machine (nix/README.md), and:"
if ((${#overrides[@]})); then
  echo "  make -C $flake build-$host && sudo make -C $flake switch   # the real zscaler-docker"
fi
echo "  commit and push nix/hosts/$dir/hardware-configuration.nix"
