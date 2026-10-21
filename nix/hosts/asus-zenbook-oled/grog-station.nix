# This notebook as a grog station (github.com/ericdallo/grog), now that its
# screen is broken: a second boot entry, "NixOS - grog", where it only runs
# grog, like a grognix. Its skin shows on an HDMI screen whenever one is
# plugged in. The personal system stays as "NixOS - Default".
#
# - `reboot-into grog` or `reboot-into personal` boots the other one, once,
#   without having to see GRUB's menu.
# - Booted into grog, rebuild with `nixos-rebuild boot` (the boot menu) and
#   then `nixos-rebuild test --specialisation grog` (the running system):
#   `switch` alone would turn it into the personal system until the next boot,
#   so it refuses to.
{ config, lib, pkgs, self, ... }:

let
  name = "grog";
  # Boot into grog unless told otherwise (`reboot-into personal`, or GRUB's
  # menu).
  stationByDefault = true;

  # GRUB's entries (install-grub.pl): the system itself, then each
  # specialisation by its configurationName.
  personalEntry = "NixOS - Default";
  stationEntry = "NixOS - ${name}";

  # SSH is the way in with the screen broken: the key greg logs in with on
  # his other machines (github, in gpg-agent).
  sshKeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/mneUevh8ZhA8gksSw1u6gLayl45pseU1gefmyW2ndd0uvG/nQyhStC+LaIU1fQ5EOYkaPyweU8FTO9JQCLgAfCOieTQrE0pHiujj50dVQuSjbA9OJJowNZO/Iom4CAcG3y0zXEShBBPNePNXYNd/TcVaLXoDQ/a2x/Go9CrOKv8KCdFu0fblZwTzk5gFtODVbsUS9Yr+bBca6mFJ5CjKher3GxeAJ5ZH1nXnzarPBAOS2d+3J/VkGGz+R8zdIBu490DnDM4eZExEftxvCxfVrTt7FtSSMgxSacWZifRV9zs2acc9xHBnNO8J2WYM3dTIdQ2BJCv6m+gn5UwqZkEtRj/B6kH0bCTimLG8UthAucnpwkn8kguzCghpdHEZS5DKdx5Bq6H3jldYn4jJkZbFB9Vt6l21jEPv+tszaM0VYnruyhqdXxo7yCik28e/2KFgoVNDu3nngEC1HGJMCRc2SjMjLCzaNcoOz1c/A38FcK9u7HnHKvM1z/tC6DXURZ55rxYo9nzC3hY9GHsG5aJ37mYh7khY1CABse/1HnoQ5YRc8MRNvk/AOXLyR5YSupi74wLTbPLT3GgtZeEbEqDNy4eekxNUjctsqQTwrOpxJnn79MXUjfz3unMiWw8ZtfCE0z3BtPMW4EyjXyTagH536boFYuRDAQMUJyB8kgOZlQ== ericdallo06@hotmail.com"
  ];

  rebootInto = pkgs.writeShellApplication {
    name = "reboot-into";
    text = ''
      case "''${1:-}" in
        personal) entry="${personalEntry}" ;;
        ${name}) entry="${stationEntry}" ;;
        *)
          echo "usage: reboot-into personal|${name}  (boots it once, then the default again)" >&2
          exit 2
          ;;
      esac
      # What grub-reboot does: GRUB boots next_entry once, then forgets it.
      sudo ${pkgs.grub2}/bin/grub-editenv /boot/grub/grubenv set next_entry="$entry"
      echo "Rebooting into $entry..."
      sudo ${config.systemd.package}/bin/systemctl reboot
    '';
  };
in
{
  assertions = [{
    # Inside the specialisation, config.specialisation is empty.
    assertion = config.isSpecialisation || builtins.attrNames config.specialisation == [ name ];
    message = "grog-station.nix: GRUB's default entry 1 is the only specialisation, ${name}.";
  }];

  boot.loader.grub.default = if stationByDefault then 1 else 0;

  environment.systemPackages = [ rebootInto ];

  # Reachable as gregnix-personal.local from either boot.
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  # Booted into grog, `switch` to the personal system would stop grog until
  # the next boot. (Its PATH has no coreutils: no cat.)
  system.preSwitchChecks.stayOnGrog = ''
    if [ -e /etc/specialisation ] && [ "$(< /etc/specialisation)" = ${name} ] \
      && [ ! -e "$1/etc/specialisation" ] && { [ "$2" = switch ] || [ "$2" = test ]; }; then
      echo "Booted into ${name}, which this would stop. Instead:" >&2
      echo "  sudo nixos-rebuild boot --flake ~/.dotfiles/nix#${config.networking.hostName}" >&2
      echo "  sudo nixos-rebuild test --flake ~/.dotfiles/nix#${config.networking.hostName} --specialisation ${name}" >&2
      exit 1
    fi
  '';

  # grog's own user, only logged in on its boot.
  users.users.grog = {
    isNormalUser = true;
    description = "grog";
    extraGroups = [ "audio" "networkmanager" ];
    linger = false;
    openssh.authorizedKeys.keys = sshKeys;
  };
  services.displayManager.sddm.settings.Users.HideUsers = "grog";

  users.users.greg.openssh.authorizedKeys.keys = sshKeys;

  specialisation.${name}.configuration = { config, ... }: {
    imports = [ self.inputs.grog.nixosModules.default ];

    # "NixOS - grog" in GRUB's menu. Should this system install the boot
    # loader itself (`nixos-rebuild switch --specialisation grog`), it's the
    # first entry: the default then.
    boot.loader.grub.configurationName = name;
    boot.loader.grub.default = lib.mkForce 0;
    # Which boot this is, for scripts (Makefile, preSwitchChecks).
    environment.etc.specialisation.text = name;

    # The broken built-in screen stays off: grog shows on HDMI, whenever a
    # screen is plugged in there.
    boot.kernelParams = [ "video=eDP-1:d" ];

    # As on a grognix (github.com/ericdallo/grog, body/grognix). Paid with an
    # API key in /etc/grog/secrets.env, or a ChatGPT subscription (`grog
    # login`), kept out of this config.
    services.grog = {
      enable = true;
      user = "grog";
      # Tuned for this Core Ultra 7 155H, measured on it (grog's
      # plans/voice.md): Parakeet in fp32 hears more on its own mics (14 of
      # 15 against 12 of 15), for ~2.6 GB more (two of them, with partials),
      # and with 4 threads it's as fast as int8 with 2. Supertonic is fastest
      # on its 6 performance cores: the first sentence in 0.16 to 0.36 s.
      voice = {
        enable = true;
        sttPrecision = "fp32";
        settings = {
          stt.threads = 4;
          tts.threads = 6;
        };
      };
      # The volume, how the machine is doing, and a shell (as grog, who can
      # use sudo).
      hands.enable = true;
      # Shown by cage, below, rather than by a desktop session.
      skin = {
        enable = true;
        user = null;
      };
      settings.skin.captions = true;
      # Updates when asked (by voice, on its screen, or `grog update`): this
      # flake with grog's input at the latest push, built as greg, switched
      # to staying in this specialisation.
      update = {
        enable = true;
        flake = "/home/greg/.dotfiles/nix";
      };
    };

    users.users.grog = {
      extraGroups = [ "wheel" ];
      # Its session (PipeWire, grog-voice, its hands) starts at boot, with or
      # without a screen, and outlives the kiosk's.
      linger = lib.mkForce true;
    };
    security.sudo.extraRules = [{
      users = [ "grog" ];
      commands = [{
        command = "ALL";
        options = [ "NOPASSWD" ];
      }];
    }];

    # Nothing but grog's skin on the screen, logged in as grog: a kiosk.
    services.cage = {
      enable = true;
      user = "grog";
      # pam_systemd gives the session CAP_WAKE_ALARM (ambient), and WebKit's
      # sandbox (bubblewrap) won't start with it: the skin goes without.
      program = pkgs.writeShellScript "grog-skin-kiosk" ''
        exec ${pkgs.util-linux}/bin/setpriv --inh-caps=-all --ambient-caps=-all -- \
          ${lib.getExe config.services.grog.skin.package} ${config.environment.variables.GROG_URL}
      '';
      # No window decorations; the screen plugged in last shows it; and
      # Ctrl+Alt+F2 still reaches a console.
      extraArguments = [ "-d" "-m" "last" "-s" ];
    };
    # Back after Ctrl+Q, or a crash.
    systemd.services.cage-tty1.serviceConfig = {
      Restart = "always";
      RestartSec = 2;
    };
    # Switching (an update, say) starts getty.target, whose login prompt on
    # tty1 would stop cage.
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;
    # No login screen, nor X.
    services.displayManager.sddm.enable = lib.mkForce false;
    services.xserver.enable = lib.mkForce false;

    # grog speaks and listens through USB audio whenever some is plugged in
    # (the speakerphone), rather than through HDMI or the built-in audio, at
    # 90% to begin with (WirePlumber's default is 40%).
    services.pipewire.wireplumber.extraConfig."50-grog-audio" = {
      "monitor.alsa.rules" = [{
        matches = [
          { "node.name" = "~alsa_output.usb-.*"; }
          { "node.name" = "~alsa_input.usb-.*"; }
        ];
        actions.update-props."priority.session" = 5000;
      }];
      "wireplumber.settings"."device.routes.default-sink-volume" = 0.729;
    };

    # A server never sleeps, lid closed or not.
    systemd.sleep.settings.Sleep = {
      AllowSuspend = "no";
      AllowHibernation = "no";
      AllowHybridSleep = "no";
      AllowSuspendThenHibernate = "no";
    };
    services.logind.settings.Login.HandleLidSwitch = lib.mkForce "ignore";
    # Power saving makes SSH laggy on Wi-Fi.
    networking.networkmanager.wifi.powersave = false;

    # Plugged in for good: it may always turbo. auto-cpufreq's "auto" turns
    # turbo on only under sustained load, too late for grog's bursts (a
    # second or so to write down what was said, or synthesize a sentence),
    # which then ran at 1.4 GHz: with turbo, Parakeet takes 0.10 s rather
    # than 0.27 s, and grog's first sentence 0.16 to 0.36 s rather than up
    # to 0.73 s.
    services.auto-cpufreq.settings.charger.turbo = lib.mkForce "always";
    # common-pc-laptop turns TLP on, which fights auto-cpufreq (see
    # hosts/asus-zenbook-s14).
    services.tlp.enable = lib.mkForce false;

    # Always plugged in: the battery lasts longer stopping at 80%. ASUS
    # forgets it on each boot, and asus-wmi adds the knob a bit after boot.
    systemd.services.battery-charge-limit = {
      description = "Stop charging the battery at 80%";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        knob=/sys/class/power_supply/BAT0/charge_control_end_threshold
        for _ in $(seq 30); do
          [ -e "$knob" ] && break
          sleep 1
        done
        echo 80 > "$knob"
      '';
    };

    # What only the personal system needs. VirtualBox and printing stay:
    # they're in the initrd (a .link unit, a modprobe blacklist), which then
    # would no longer be the personal system's, and /boot (512 MB, Windows'
    # and Ubuntu's too) has room for few.
    services.flatpak.enable = lib.mkForce false;
    services.samba.enable = lib.mkForce false;
    services.samba-wsdd.enable = lib.mkForce false;
    # It would also run in grog's session, sharing its screen.
    services.sunshine.enable = lib.mkForce false;
    systemd.user.services.sunshine.enable = lib.mkForce false;
    services.zscaler.enable = lib.mkForce false;
    virtualisation.docker.enable = lib.mkForce false;
  };
}
