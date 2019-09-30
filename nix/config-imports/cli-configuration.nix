{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    vim
    ag
    curl
    emacs
    gitFull
    jq
    lshw
    manpages
    openssl
    telnet
    unrar
    unzip
    usbutils
    xclip
    grub
    oh-my-zsh
    tmux
    tmuxinator
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
      ohMyZsh = {
        enable = true;
        plugins = [ "git" "sudo" "docker" "kubectl" ];
      };
      interactiveShellInit = ''
        export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

        # Customize your oh-my-zsh options here
        ZSH_THEME="simple"
        plugins=(git)

        source $ZSH/oh-my-zsh.sh
      '';
      promptInit = "";
    };
    bash.enableCompletion = true;
  };
}
