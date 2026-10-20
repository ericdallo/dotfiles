# NixOS

The NixOS configurations of all my machines, as a flake (`flake.nix`).

- `configuration.nix`, `configurations/`: the system, shared by every host.
- `hosts/<machine>/`: what's specific to each machine (hardware, programs),
  each a `nixosConfigurations.<hostname>` in `flake.nix`.
- `bootstrap.sh`: turns a fresh NixOS install into one of the hosts.
- `stubs/`: stand-ins for private flake inputs, until there's a key.
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

Install NixOS the normal way, then one script turns it into the host.

1. **Boot the official NixOS ISO**, the graphical one (BIOS: Secure Boot
   off; on ASUS, F2 is the BIOS and Esc the boot menu). On new hardware,
   pick the entry with the newest kernel, e.g. "GNOME (Linux 7.2.10)": the
   installed system then gets that kernel too.
2. **Install**: user `greg`; **Erase disk**, **Encrypt system** and swap
   **with hibernate**; desktop: **No desktop** (the flake brings its own).
   Reboot.
3. **Bootstrap**: log in, get online (`nmtui`), and
   ```sh
   nix-shell -p git --run 'git clone https://github.com/ericdallo/dotfiles ~/.dotfiles'
   ~/.dotfiles/nix/bootstrap.sh gregnix-s14
   ```
   It writes `hosts/<machine>/hardware-configuration.nix` from what the
   installer generated (with the encrypted swap only its
   `configuration.nix` declares), builds the host and makes it the next
   boot. Reboot: the LUKS passphrase, and you're in Hyprland.
4. **Finish**, with the GitHub SSH key (YubiKey) set up: commit and push the
   new `hardware-configuration.nix`. The private `zscaler-docker` input
   needs that key, so without it the bootstrap built with its stand-in
   (`stubs/`): rebuild for the real one,
   `make -C nix build-gregnix-s14 && sudo make -C nix switch`.

### A new machine

1. `hosts/<machine>/default.nix`, starting from `hosts/asus-zenbook-s14`.
2. Its line in `flake.nix`'s `nixosConfigurations`.
3. Push, and install as above: the bootstrap writes its
   `hardware-configuration.nix`.

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
