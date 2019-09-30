source ~/.critical-keys

export EDITOR=vim
export PI=192.168.1.108

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
export NIX_PATH="$HOME/bin:/run/wrappers/bin:$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
export PATH="$PATH:$NIX_PATH"
export GRADLE_OPTS=-Xmx1024m

[[ -s ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -s ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -s ~/.functions ]] && source ~/.functions

if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi