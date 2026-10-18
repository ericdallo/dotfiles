{ lib, ... }:

{
  # Sunshine: self-hosted stream host paired with the Moonlight app — the
  # remote-desktop path into this notebook (TeamViewer-style, but over
  # Tailscale). Typical use: phone/tablet runs Moonlight and reaches work
  # stuff that is VPN-gated to this machine.
  #
  # First-time setup (once, locally): open https://localhost:47990, create
  # the web-UI credentials, then pair Moonlight from the phone using this
  # machine's Tailscale name/IP and the PIN flow.
  #
  # `settings`/`applications` are deliberately NOT set: the NixOS module
  # only pins a read-only config file when they are customised; leaving
  # them out keeps the whole web UI writable.
  services.sunshine = {
    enable = true;

    # DRM/KMS screen capture on Wayland (Hyprland) requires CAP_SYS_ADMIN;
    # this installs a security wrapper carrying that capability. Input
    # injection works via uinput, which the module enables.
    capSysAdmin = true;

    # Runs as a systemd *user* unit bound to graphical-session.target, so a
    # logged-in session is required (sitting at SDDM is not enough).
    autoStart = true;

    # Keep the LAN closed: access is Tailscale-only. tailscale0 is already
    # a trusted interface (hardware.nix), so the tailnet reaches Sunshine
    # without opening firewall ports on other interfaces.
    openFirewall = false;
  };

  # autoStart hooks the unit to graphical-session.target, but this Hyprland
  # session (SDDM -> start-hyprland, no UWSM) never activates that target,
  # so sunshine would never start. Hook it to default.target instead: it is
  # reached on every login, and sunshine does not need the Wayland session
  # environment anyway (KMS capture + uinput input).
  systemd.user.services.sunshine.wantedBy = lib.mkForce [ "default.target" ];

  # It is a *global* user unit (/etc/systemd/user), so EVERY user manager
  # starts it — including the SDDM greeter's (sddm, a system user). That
  # instance grabs the ports at the login screen and makes greg's die with
  # "Couldn't bind RTSP server to port [48010], Address already in use".
  # Only start it for regular (non-system) users.
  systemd.user.services.sunshine.unitConfig.ConditionUser = "!@system";
}
