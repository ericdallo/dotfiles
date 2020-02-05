source ~/.critical-keys

# TODO use flutter as a nix derivation
export PATH="$PATH:$HOME/flutter/bin"

export EDITOR=emacs
export DOTFILES_DIR="$HOME/.dotfiles"
export GRADLE_OPTS=-Xmx1024m
export GPG_TTY=$(tty)
export GOPATH="$HOME/gocode"
export PATH="$PATH:$GOPATH/bin"

[[ -s ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -s ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -s ~/.functions ]] && source ~/.functions
[[ -s ~/.extra ]] && source ~/.extra

[[ $TERM == *"rxvt"* ]] && wmctrl -r :ACTIVE: -b add,fullscreen
