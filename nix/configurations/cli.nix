{ pkgs, ... }:

{
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
