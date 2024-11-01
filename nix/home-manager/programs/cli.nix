{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    aircrack-ng
    hashcat
    # hashcat-utils
    hcxtools
    stable.awscli
    stable.appimage-run
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    cachix
    curl
    docker-compose
    espeak
    fd
    file
    ffmpeg
    gitFull
    gnumake
    stable.gnupg
    google-drive-ocamlfuse
    go
    gotop
    grub2
    inotify-tools
    jq
    killall
    libvterm-neovim
    lshw
    man-pages
    nssTools
    mediainfo
    neofetch
    nodejs_20
    curlftpfs
    openssl
    pinentry
    ripgrep
    rxvt-unicode
    stable.sbt
    shellcheck
    sqlite
    inetutils
    translate-shell
    tree
    unrar
    unzip
    usbutils
    wget
    wirelesstools
    wmctrl
    xdotool
    xsel
  ];
}
