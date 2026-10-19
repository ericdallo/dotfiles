{ ... }:

{
  # Laptop power management, shared by every host (they're all laptops).
  powerManagement.enable = true;
  services.thermald.enable = true; # Intel thermal management

  # GNOME's power-profiles-daemon conflicts with auto-cpufreq, so desktop.nix
  # disables it.
  services.auto-cpufreq = {
    enable = true; # dynamically switches governor based on load
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
}
