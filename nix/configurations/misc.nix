{ pkgs, ... }:

{
  console = {
    useXkbConfig = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  # Automatic timezone via IP geolocation (oneshot at boot + hourly timer).
  # Replaces automatic-timezoned, whose geoclue backend never answers here
  # (DBus NoReply), so it failed on every boot and left the clock in UTC.
  # Caveat: behind a full-tunnel VPN it follows the VPN egress country.
  services.tzupdate.enable = true;
}
