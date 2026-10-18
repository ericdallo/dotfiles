{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    # ~/.config/nvim is symlinked to this repo (see common.nix), and its
    # init.lua is the hand-written LazyVim bootstrap. Without this, HM writes
    # its own init.lua (provider settings only) on top of it — i.e. INSIDE the
    # repo — which drops LazyVim and gets committed as a dangling
    # /nix/store symlink. Sideloading passes HM's init through the nvim
    # wrapper (`--cmd`) instead, leaving init.lua to us.
    sideloadInitLua = true;
    # HM master (2026-05) requires the structured form here — passing
    # bare derivations triggers a `plugins.<entry>.runtime' does not exist`
    # error against nixpkgs's neovim plugin-submodule. Wrap each in
    # `{ plugin = ...; }`.
    plugins = with pkgs.vimPlugins; [
      { plugin = packer-nvim; }
      { plugin = vim-nix; }
    ];
  };
}
