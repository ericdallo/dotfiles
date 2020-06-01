source ~/.critical-keys

export EDITOR="emacs -nw"
export DOTFILES_DIR="$HOME/.dotfiles"
export GRADLE_OPTS=-Xmx1024m
export GPG_TTY=$(tty)
export GOPATH="$HOME/gocode"
export PATH="$PATH:$HOME/.emacs.d/bin"

### Extra paths

# TODO use flutter as a nix derivation
export PATH="$PATH:$HOME/flutter/bin"

[[ -s ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -s ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -s ~/.functions ]] && source ~/.functions
[[ -s ~/.extra ]] && source ~/.extra

[[ $TERM == *"rxvt"* ]] && wmctrl -r :ACTIVE: -b add,fullscreen

# move to nix
xset r rate 220 50
