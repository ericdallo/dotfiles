{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    aircrack-ng
    aider-chat
    master.ollama
    llama-cpp
    stable.lmstudio
    claude-code
    hashcat
    # hashcat-utils
    hcxtools
    awscli
    stable.appimage-run
    aspell
    aspellDicts.en
    # aspellDicts.en-computers: removed from nixpkgs (its upstream URL
    # turned into a gambling website).
    cachix
    curl
    copilot-language-server
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
    github-mcp-server
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
    fastfetch
    # Node.js 20 left nixpkgs at its end of life (2026-04-30): the next LTS.
    nodejs_22
    # curlftpfs: removed from nixpkgs (no FUSE 3 support). `rclone mount`
    # mounts FTP too.
    openssl
    pinentry-curses
    ripgrep
    rxvt-unicode
    stable.sbt
    shellcheck
    sqlite
    inetutils
    python313Packages.trafilatura
    translate-shell
    tree
    unrar
    unzip
    zip
    usbutils
    wget
    wl-clipboard
    wtype
    wirelesstools
    wmctrl
    xdotool
    xsel
    xclip
  ];
}
