{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # dolphin-emu-beta
    aseprite
    # Lutris 0.5.22 from `master`: `stable` only had 0.5.19 (frequent
    # freezes), and the pinned `nixpkgs` rev has an uncached openldap whose
    # `test017-syncreplication-refresh` fails; `master` is fully cached.
    master.lutris
    steam
    # `wine`, `gamemode` and `winetricks` are launched *inside* lutris's
    # bubblewrap FHS sandbox, whose /lib/libc.so.6 comes from the same channel
    # as `lutris`. They MUST come from the same channel (`master`): mixing
    # glibc versions (e.g. 2.42 loader + 2.40 sandbox libc.so.6) dies with
    # `symbol lookup error: /lib/libc.so.6: undefined symbol:
    # __nptl_change_stack_perm`. Keep these in lock-step with `lutris`.
    #
    # WoW64 build (not plain `wine`, which is 32-bit only): modern games such
    # as the Godot-based ones here ship 64-bit PE32+ executables, and a 32-bit
    # Wine rejects them with `ShellExecuteEx failed: Bad EXE format`. The win64
    # prefix must match (recreate any old win32 prefix). Staging (11.9) for
    # the newest game-compat patches; swap for `.stable` if it misbehaves.
    master.wineWow64Packages.staging
    master.godot
    audacity
    steam-run
    cemu
    master.winetricks
    master.gamemode
  ];
}
