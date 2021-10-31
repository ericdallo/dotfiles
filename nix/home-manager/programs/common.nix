{ ... }:

{
  imports = [
    ./cli.nix
    ./vim.nix
    ./shell.nix
    ./git.nix
    ./network-manager.nix
    ./tmux.nix
    ./tmuxinator.nix
    ./urxvt.nix
    ./emacs.nix
  ];

  xdg.mimeApps = {
      enable =  true;
      defaultApplications = {
          "inode/directory" = [ "nautilus.desktop" ];
          "application/pdf" = [ "google-chrome.desktop" ];
      };
  };
}
