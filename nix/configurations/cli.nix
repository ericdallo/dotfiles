{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
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
    pinentry
    ripgrep
    rxvt_unicode-with-plugins
    stable.sbt
    telnet
    translate-shell
    tree
    unrar
    unzip
    usbutils
    vim
    wget
    wirelesstools
    wmctrl
    xclip
    xsel
  ];

  services.openssh.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];

  programs = {
     zsh = {
       enable = true;
       syntaxHighlighting.enable = true;
       enableCompletion = true;
       ohMyZsh = {
         enable = true;
         plugins = [ "git" "sudo" "docker" ];
         theme = "simple";
       };
       interactiveShellInit = ''
         export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/
         plugins=(git sudo docker)

         source $ZSH/oh-my-zsh.sh
       '';
       promptInit = "";
     };

    ssh.startAgent = false;
    gnupg.agent.enable = true;
    gnupg.agent.enableSSHSupport = true;

    bash.enableCompletion = true;
  };
}
