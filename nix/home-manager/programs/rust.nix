{ pkgs, ... }:

{
  home.packages = with pkgs; [
      rust-analyzer
      rustup
  ];
}
