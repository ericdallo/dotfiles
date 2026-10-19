# NixOS

The NixOS configurations of all my machines, as a flake (`flake.nix`).

- `configuration.nix`, `configurations/`: the system, shared by every host.
- `hosts/<machine>/`: what's specific to each machine (hardware, disk
  layout, programs), each a `nixosConfigurations.<hostname>` in `flake.nix`.
- `hosts/installer/`: the installer ISO.
- `home-manager/`: my user's programs and dotfiles.

| Host               | Machine                                                     |
| ------------------ | ----------------------------------------------------------- |
| `gregnix-s14`      | ASUS Zenbook S14 UX5406AA (2026, Panther Lake)              |
| `gregnix-personal` | ASUS Zenbook 14 OLED UX3405MA (broken screen: grog station) |
| `gregnix-deluxe`   | ASUS ZenBook 3 Deluxe UX490UAR                              |

## Day to day

```sh
make -C nix build-gregnix-s14   # build a host (result/)
make -C nix switch              # activate it
make -C nix update              # bump flake.lock
```

## Installing a machine

NixOS only: whatever is on the disk, Windows included, is erased. One USB
stick, and most of the time goes into downloading from cache.nixos.org.

1. **Push** first: the installer clones github.com/ericdallo/dotfiles.
2. **Make the USB stick**, on any machine with this repo:
   ```sh
   make -C nix iso                   # newest kernel, nmtui, gregnix-install
   lsblk                             # which one is the stick? e.g. sda
   make -C nix usb DEVICE=/dev/sda   # refuses anything but a USB disk
   ```
3. **BIOS** (F2 while powering on): disable Secure Boot. Then boot the stick
   (Esc while powering on: boot menu).
4. **Get online**: `nmtui` for Wi-Fi, or a cable, or phone USB tethering.
5. **Install**: `sudo gregnix-install gregnix-s14`. It
   - checks the host evaluates, before touching the disk;
   - shows the disk, and erases it only once you type the host's name;
   - asks for the LUKS passphrase, the one boot asks for (US keymap);
   - installs, copies this repo to `~/.dotfiles` and the Wi-Fi connections,
     and asks for greg's password.
6. **Reboot** without the stick: the LUKS passphrase, and you're in Hyprland
   (home-manager links the dotfiles on that first boot).

The flake's private inputs (`zscaler-docker`, over SSH) ride along in the
ISO, so installing needs no GitHub key. After bumping one in `flake.lock`,
rebuild the ISO.

### A new machine

1. `hosts/<machine>/default.nix`, starting from `hosts/asus-zenbook-s14`,
   and its `disko.nix`: the disk layout, both what the installer formats
   and the host's file systems.
2. Its line in `flake.nix`'s `nixosConfigurations`.
3. Push, and install as above.

### Zenbook S14 notes

- Panther Lake is new, hence `linuxPackages_latest`: its audio (SoundWire)
  needs Linux 7.2 or newer, and each release fixes more.
- Display scale: `environment.etc."hypr/host.conf"` in
  `hosts/asus-zenbook-s14` (1.6; 1.8 is bigger).
- With auto-login, nothing unlocks the GNOME keyring at login: the first
  app to use it asks for its password. An empty one is fine on an encrypted
  disk.
- Slow Wi-Fi on a Wi-Fi 7 router? Intel's EHT bug, seen on other Panther
  Lake laptops: `boot.extraModprobeConfig = "options iwlwifi disable_11be=Y";`.
