{ pkgs, ... }:

{
  environment.systemPackages = with pkgs;

  let
    stable = import (fetchTarball http://nixos.org/channels/nixos-19.09/nixexprs.tar.xz) {};
  in [
    ag
    appimage-run
    curl
    emacs
    espeak
    file
    ffmpeg
    gitFull
    gnumake
    gotop
    grub
    home-manager
    imagemagick
    inotify-tools
    jq
    killall
    lshw
    manpages
    mediainfo
    openssl
    oh-my-zsh
    ripgrep
    stable.rxvt_unicode-with-plugins
    s3cmd
    srt-to-vtt-cl
    telnet
    tmux
    tmuxinator
    tree
    unrar
    unzip
    urxvt_font_size
    usbutils
    vim
    wget
    wirelesstools
    wmctrl
    xsel
  ];

  fonts = {
    fonts = with pkgs; [
      emacs-all-the-icons-fonts
      hack-font
    ];
  };

  programs = {
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [ "git" "sudo" "docker" "kubectl"];
      };
      interactiveShellInit = ''
        export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

        # Customize your oh-my-zsh options here
        ZSH_THEME="simple"
        plugins=(git sudo docker kubectl)

        source $ZSH/oh-my-zsh.sh
      '';
      promptInit = "";
    };
    bash.enableCompletion = true;

    tmux = {
      enable = true;
      clock24 = true;
    };
  };

  systemd.user.services."urxvtd" = {
    enable = true;
    description = "rxvt unicode daemon";
    wantedBy = [ "default.target" ];
    path = [ pkgs.rxvt_unicode ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.rxvt_unicode}/bin/urxvtd -q -o";
  };

}
