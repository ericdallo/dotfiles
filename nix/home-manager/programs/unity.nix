# From https://github.com/huantianad/nixos-config/blob/main/modules/desktop/programs/unity.nix
{ options, config, pkgs, lib, inputs, ... }:

let
  cfg = config.modules.desktop.programs.unity;

  unityhub = pkgs.stdenv.mkDerivation rec {
    name = "unityhub";
    version = "3.3.0";

    src = pkgs.fetchurl {
      url = "https://hub-dist.unity3d.com/artifactory/hub-debian-prod-local/pool/main/u/unity/unityhub_amd64/unityhub-amd64-${version}.deb";
      sha256 = "sha256-W5NPOvIUFDyNuauUDXD/jaMD5USPO/7Wty6FuxtFbRk=";
    };

    nativeBuildInputs = with pkgs; [
      dpkg
      makeShellWrapper
    ];

    extraLibs = with pkgs; with xorg; [
      glibc
      gcc-unwrapped
      cups
      gtk3
      xorg.libXcomposite
      xorg.libXrandr
      xorg.libXext
      xorg.libXdamage
      xorg.libXfixes
      xorg.libxcb
      xorg.libxshmfence
      xorg.libXScrnSaver
      xorg.libXtst
      expat
      libxkbcommon
      lttng-ust_2_12
      krb5
      at-spi2-core
      alsa-lib
      libpulseaudio # Not a ldd thing, but needed for sound to work
      nss_latest
      libdrm
      mesa
      nspr
      atk
      dbus
      at-spi2-atk
      gnome2.pango

      libva
      openssl
      openssl_1_1
      cairo
      xdg-utils
      libnotify
      libuuid
      libsecret
      udev
      libappindicator
      wayland
      cpio
      icu

      # Editor dependencies
      libglvnd #ligbl
      xorg.libX11
      xorg.libXcursor
      glib
      gdk-pixbuf
      libxml2
      zlib
      clang

      # these are probably not needed
      xorg.libXinerama
      hicolor-icon-theme

      # My Unity projects depend on these
      harfbuzz
      libogg

      # Bug Reporter dependencies
      fontconfig
      freetype
      lsb-release
    ];

    fhsEnv = pkgs.buildFHSUserEnv {
      name = "${name}-fhs-env";
      targetPkgs = pkgs: unityhub.extraLibs;
      runScript = "";
    };

    sourceRoot = ".";
    unpackPhase = "dpkg -x $src .";

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir $out
      mv usr/share/ $out/share
      mv opt/ $out/opt
      # `unityhub` is a shell wrapper that runs `unityhub-bin`
      # Which we don't need and replace with our own custom wrapper
      cat >$out/opt/unityhub/unityhub <<EOL
      #!${pkgs.bash}/bin/bash
      export GSETTINGS_SCHEMA_DIR=${pkgs.glib.getSchemaPath pkgs.gtk3}
      ${fhsEnv}/bin/${name}-fhs-env $out/opt/unityhub/unityhub-bin "\$@"
      EOL
      chmod +x $out/opt/unityhub/unityhub
      # Link binary
      mkdir $out/bin
      ln -s $out/opt/unityhub/unityhub $out/bin/unityhub
      # Replace absolute path in desktop file to correctly point to nix store
      substituteInPlace $out/share/applications/unityhub.desktop \
        --replace /opt/unityhub/unityhub $out/opt/unityhub/unityhub
      # From the .deb's postInstall hook, not sure if necessary
      chmod 4755 '$out/opt/unityhub/chrome-sandbox' || true
      runHook postInstall
    '';

    dontStrip = true;

    meta = with lib; {
      description = "Download and manage Unity Projects and installations.";
      homepage = "https://unity3d.com/";
      license = licenses.unfree;
      maintainers = with maintainers; [ huantian ];
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  home.packages = [
    pkgs.unityhub
    pkgs.mono
    pkgs.omnisharp-roslyn
    pkgs.dotnet-sdk
  ];
}
