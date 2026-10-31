{ config, lib, pkgs, ... }:

let
  # The CPU policy for the current power source, applied once: at boot, on
  # every charger change (udev) and after resume. On AC the performance
  # governor; on battery powersave, preferring efficiency (EPP and EPB
  # balance_power). Turbo stays on in both: with HWP the CPU boosts only the
  # cores that need it. Off on battery, it capped the S14's P-cores at
  # 2.1 GHz instead of 4.9: sustained work, like the catch-up after opening
  # the lid, took twice as long.
  cpuPowerPolicy = pkgs.writeShellApplication {
    name = "cpu-power-policy";
    text = ''
      power=battery
      for supply in /sys/class/power_supply/*; do
        case "$(cat "$supply/type" 2>/dev/null)" in
          Mains | USB)
            if [ "$(cat "$supply/online" 2>/dev/null)" = 1 ]; then power=AC; fi
            ;;
        esac
      done

      if [ "$power" = AC ]; then
        governor=performance epp=performance epb=4
      else
        governor=powersave epp=balance_power epb=8
      fi

      set_to() {
        if [ -w "$2" ]; then
          echo "$1" > "$2" || echo "could not set $2 to $1" >&2
        fi
      }
      for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
        set_to "$governor" "$cpu/cpufreq/scaling_governor"
        # The performance governor pins EPP to performance by itself.
        if [ "$governor" != performance ]; then
          set_to "$epp" "$cpu/cpufreq/energy_performance_preference"
        fi
        set_to "$epb" "$cpu/power/energy_perf_bias"
      done
      set_to 0 /sys/devices/system/cpu/intel_pstate/no_turbo
      echo "$power: $governor governor, EPP $epp, EPB $epb, turbo on"
    '';
  };

  # Hosts with neither auto-cpufreq nor TLP (which nixos-hardware's
  # common-pc-laptop turns on) get cpuPowerPolicy.
  ownPolicy = !config.services.auto-cpufreq.enable && !config.services.tlp.enable;
  restartPolicy = "${config.systemd.package}/bin/systemctl --no-block restart cpu-power-policy.service";
in
{
  # Laptop power management, shared by every host (they're all laptops).
  powerManagement.enable = true;
  services.thermald.enable = true; # Intel thermal management

  # The default CPU power manager. GNOME's power-profiles-daemon conflicts
  # with it, so desktop.nix disables that. It polls, though: every 2s it
  # re-applies its settings through ~10 bash processes, a few % of a CPU
  # core and steady wakeups; hosts can turn it off for cpuPowerPolicy.
  services.auto-cpufreq = {
    enable = lib.mkDefault true; # dynamically switches governor based on load
    settings = {
      charger = {
        governor = "performance";
        turbo = "auto";
      };
      battery = {
        governor = "powersave";
        turbo = "never";
      };
    };
  };

  systemd.services.cpu-power-policy = lib.mkIf ownPolicy {
    description = "CPU power policy for the current power source";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.getExe cpuPowerPolicy;
    };
  };
  # restart, not start: a change while it runs must still be applied.
  services.udev.extraRules = lib.mkIf ownPolicy ''
    SUBSYSTEM=="power_supply", ATTR{type}=="Mains|USB", ACTION=="add|change", RUN+="${restartPolicy}"
  '';
  # In case the charger changed while asleep, with no event on resume.
  powerManagement.resumeCommands = lib.mkIf ownPolicy restartPolicy;
}
