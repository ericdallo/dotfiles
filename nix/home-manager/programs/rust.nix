{ pkgs, ... }:

{
  home.packages = with pkgs; [
      rust-analyzer
      cargo
      gcc
      rustc
      rustfmt
      # rustup
  ];
}
