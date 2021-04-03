{ pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  [
    ag
    stable.appimage-run
    aspell
    aspellDicts.en
    aspellDicts.en-computers
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
    inotify-tools
    jq
    killall
    libvterm-neovim
    lshw
    manpages
    nssTools
    mediainfo
    neofetch
    nixfmt
    openfortivpn
    openssl
    oh-my-zsh
    pinentry
    ripgrep
    rxvt_unicode-with-plugins
    stable.sbt
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
    xclip
    xsel
  ];

  services.openssh.enable = true;

  programs = {
    ssh.startAgent = false;
    gnupg.agent.enable = true;
    gnupg.agent.enableSSHSupport = true;

    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      ohMyZsh = {
        enable = true;
        plugins = [ "git" "sudo" "docker"];
      };
      interactiveShellInit = ''
        export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/
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
