# shellcheck shell=bash
# gregnix-install <host>: ERASE this machine's disk and install <host>, a
# nixosConfiguration of github.com/ericdallo/dotfiles (nix/flake.nix), in one
# go. Runs on the installer ISO (nix/hosts/installer), once online (nmtui).
#
#   1. clones the dotfiles and checks <host> evaluates, before touching disk
#   2. partitions, encrypts, formats and mounts: nix/hosts/<host>/disko.nix
#   3. nixos-install from the clone, which becomes /home/greg/.dotfiles
#   4. copies the Wi-Fi connections made here and asks for greg's password
set -euo pipefail

repo=${GREGNIX_REPO:-https://github.com/ericdallo/dotfiles}
user=greg

die() {
  echo "error: $*" >&2
  exit 1
}
step() { printf '\n\033[1;35m==> %s\033[0m\n' "$*"; }

if [[ $# -ne 1 ]]; then
  echo "usage: sudo gregnix-install <host>   (e.g. gregnix-s14)" >&2
  exit 2
fi
host=$1
[[ $EUID -eq 0 ]] || exec sudo "$0" "$@"

curl -fsS --max-time 15 https://cache.nixos.org/nix-cache-info >/dev/null ||
  die "no internet: connect first (Wi-Fi: nmtui)"

step "Cloning $repo"
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
git clone --quiet "$repo" "$work/dotfiles"
flake="$work/dotfiles/nix"

step "Evaluating $host (before touching the disk)"
nix eval --raw "$flake#nixosConfigurations.$host.config.system.build.toplevel.drvPath" >/dev/null ||
  die "$host doesn't evaluate. Is it pushed to $repo? Private flake inputs come from this ISO's store: if flake.lock bumped one, rebuild the ISO."

mapfile -t disks < <(nix eval --raw "$flake#nixosConfigurations.$host.config.disko.devices.disk" \
  --apply 'disks: builtins.concatStringsSep "\n" (map (d: d.device) (builtins.attrValues disks))')
((${#disks[@]})) || die "$host has no disk layout (nix/hosts/<host>/disko.nix)"

# The LUKS prompt at boot runs before most drivers: PS/2 and USB keyboards
# work there, others (I2C) might not.
grep -qs 'Name="AT Translated Set 2 keyboard"' /proc/bus/input/devices ||
  echo "warning: the built-in keyboard isn't PS/2: if it doesn't type at the boot's LUKS prompt, use a USB keyboard there" >&2

step "This ERASES everything on: ${disks[*]}"
lsblk -o NAME,SIZE,MODEL,FSTYPE,LABEL "${disks[@]}" || die "disk not found: ${disks[*]}"
read -rp "Type '$host' to erase it and install: " answer
[[ $answer == "$host" ]] || die "aborted, nothing changed"

step "Partitioning, encrypting, formatting and mounting on /mnt"
echo "A LUKS passphrase set now is asked at every boot, with this same (US) keymap."
disko --mode destroy,format,mount --yes-wipe-all-disks --flake "$flake#$host"

step "Installing $host (mostly downloads from cache.nixos.org)"
nixos-install --flake "$flake#$host" --no-root-passwd --no-channel-copy

step "Copying the dotfiles to /home/$user/.dotfiles"
mkdir -p "/mnt/home/$user"
cp -a "$work/dotfiles" "/mnt/home/$user/.dotfiles"
# Pull over https (no key needed), push over ssh.
git -C "/mnt/home/$user/.dotfiles" remote set-url --push origin \
  "${repo/https:\/\/github.com\//git@github.com:}.git"
nixos-enter --root /mnt -c "chown -R $user:users /home/$user/.dotfiles"

if compgen -G '/etc/NetworkManager/system-connections/*' >/dev/null; then
  step "Copying the Wi-Fi connections made here"
  install -d -m 700 /mnt/etc/NetworkManager/system-connections
  cp -a /etc/NetworkManager/system-connections/. /mnt/etc/NetworkManager/system-connections/
fi

step "Password for $user (lock screen, ...)"
until nixos-enter --root /mnt -c "passwd $user"; do
  echo "Try again."
done

step "Done: remove the USB stick and reboot"
