{ pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  [
    ag
    appimage-run
    curl
    espeak
    fd
    file
    ffmpeg
    gitFull
    gnumake
    gnupg
    gotop
    grub
    home-manager
    imagemagick
    inotify-tools
    jq
    killall
    kubectl
    lshw
    manpages
    nssTools
    mediainfo
    neofetch
    # nixfmt
    openssl
    oh-my-zsh
    pinentry
    ripgrep
    stable.rxvt_unicode-with-plugins
    s3cmd
    srt-to-vtt-cl
    telnet
    tmux
    tmuxinator
    translate-shell
    tree
    unrar
    unzip
    urxvt_font_size
    usbutils
    vim
    wget
    wirelesstools
    wmctrl
    websocat
    xsel
  ];

  fonts = {
    fonts = with pkgs; [
      emacs-all-the-icons-fonts
      hack-font
    ];
  };

  programs = {
    gnupg.agent.enable = true;

    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [ "git" "sudo" "docker"];
      };
      interactiveShellInit = ''
        export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

        # Customize your oh-my-zsh options here
        ZSH_THEME="simple"
        plugins=(git sudo docker)

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
