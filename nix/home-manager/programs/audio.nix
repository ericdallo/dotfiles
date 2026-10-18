{ config, lib, pkgs, ... }:

let
  # nixpkgs ships Reaper as a makeWrapper script that pins LD_LIBRARY_PATH to
  # its runtime deps (openssl/ffmpeg/vlc/…) but NOT to PipeWire's JACK shim.
  # Reaper's JACK backend dlopen()s libjack.so.0 at runtime, and PipeWire's
  # libjack lives in the separate `pipewire.jack` output, which is not on the
  # default library path — so selecting JACK fails with
  #   "There was an error opening the audio hardware".
  #
  # Re-wrap Reaper to prepend PipeWire's JACK libs (exactly what `pw-jack`
  # does) so its JACK backend talks straight to PipeWire — giving low-latency
  # monitoring instead of the multi-second PulseAudio buffer. PIPEWIRE_LATENCY
  # asks PipeWire for a small quantum (256/48000 ≈ 5.3 ms); it's --set-default
  # so you can still override it from the environment. The packaged .desktop
  # uses `Exec=reaper` (PATH-relative), so the app-menu launcher resolves to
  # this wrapped binary in the user profile.
  reaper-pw-jack = pkgs.symlinkJoin {
    name = "reaper-pipewire-jack";
    paths = [ pkgs.reaper ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/reaper \
        --prefix LD_LIBRARY_PATH : ${pkgs.pipewire.jack}/lib \
        --set-default PIPEWIRE_LATENCY 256/48000
    '';
  };
in
{
  home.packages = with pkgs; [
    alsa-utils # alsamixer, speaker-test, aplay, alsactl — audio diagnostics
    reaper-pw-jack # Reaper wired to PipeWire's JACK (low-latency monitoring)
    pipewire.jack # exposes `pw-jack` to launch other audio apps on JACK
  ];
}
