source ~/.critical-keys

export EDITOR=vim
export DOTFILES_DIR="~/dev/dotfiles"
export GRADLE_OPTS=-Xmx1024m

[[ -s ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -s ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -s ~/.functions ]] && source ~/.functions

if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi