{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    aircrack-ng
    aider-chat
    master.ollama
    hashcat
    # hashcat-utils
    hcxtools
    awscli
    stable.appimage-run
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    cachix
    curl
    copilot-language-server-fhs
    docker-compose
    espeak
    envsubst
    fd
    fzf
    file
    ffmpeg
    fontconfig
    gifski
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
