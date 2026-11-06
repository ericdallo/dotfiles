{ config, lib, pkgs, ... }:

let
  airgeddon = (pkgs.airgeddon.override {
    supportEvilTwin = false;
    supportHashCracking = true;
    supportWpaWps = true;
    supportX11 = false;
  }).overrideAttrs (oldAttrs: {
    # The pinned package still derives its resource directory from bin/,
    # although its rc file, translations and plugins live under share/.
    postPatch = (oldAttrs.postPatch or "") + ''
      substituteInPlace airgeddon.sh \
        --replace-fail 'scriptfolder="''${scriptfolder%/}/"' \
          'scriptfolder="${placeholder "out"}/share/airgeddon/"'
    '';

    # Airgeddon restarts itself in tmux relative to scriptfolder. Keep the
    # wrapped script reachable there, with its original basename.
    postInstall = (oldAttrs.postInstall or "") + ''
      ln -s "$out/bin/.airgeddon-wrapped" "$out/share/airgeddon/.airgeddon-wrapped"
    '';

    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck
      bash -n "$out/bin/.airgeddon-wrapped"
      for entrypoint in "$out/bin/.airgeddon-wrapped" "$out/share/airgeddon/.airgeddon-wrapped"; do
        bash -c 'source "$1"' "$entrypoint" ${../tests/airgeddon-startup.sh}
      done
      runHook postInstallCheck
    '';
  });
in
{
  options.programs.wifiAudit.enable =
    lib.mkEnableOption "interactive Wi-Fi auditing tools for authorized networks";

  config = lib.mkIf config.programs.wifiAudit.enable {
    environment.systemPackages = with pkgs; [
      aircrack-ng
      # Dependencies and tmux support come from the nixpkgs wrapper.
      airgeddon
      clinfo
      hashcat
      hcxdumptool
      hcxtools
      iw
      wireshark-cli
    ];

    # Hashcat needs an OpenCL implementation, not just the ICD loader.
    # Register a CPU backend alongside any existing GPU drivers so the
    # offline tools do not depend on a particular GPU being supported.
    hardware.graphics = {
      enable = true;
      extraPackages = [ pkgs.pocl ];
    };
  };
}
