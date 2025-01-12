{ pkgs, ... }:

{
  services.openssh.enable = true;

  environment.shells = [ pkgs.zsh ];

  programs = {
    adb.enable = true;
    ssh.startAgent = false;
    gnupg.agent.enable = true;
    gnupg.agent.enableSSHSupport = true;

    bash.completion.enable = true;
  };
}
