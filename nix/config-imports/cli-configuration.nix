{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ag
    curl
    emacs
    espeak
    file
    ffmpeg
    gitFull
    gnumake
    grub
    home-manager
    imagemagick
    inotify-tools
    jq
    killall
    lshw
    manpages
    openssl
    oh-my-zsh
    s3cmd
    telnet
    tmux
    tmuxinator
    tree
    unrar
    unzip
    usbutils
    vim
    wget
    xclip
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
}
