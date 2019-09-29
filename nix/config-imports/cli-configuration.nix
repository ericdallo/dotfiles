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
    };
    bash.enableCompletion = true;
  };
}
