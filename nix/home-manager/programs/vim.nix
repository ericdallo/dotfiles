{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      packer-nvim
      vim-nix
    ];
  };
}
