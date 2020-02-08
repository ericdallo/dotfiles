source ~/.critical-keys

export EDITOR=emacs
export DOTFILES_DIR="$HOME/.dotfiles"
export GRADLE_OPTS=-Xmx1024m
export GPG_TTY=$(tty)
export GOPATH="$HOME/gocode"

# Extra paths

# TODO use flutter as a nix derivation
export PATH="$PATH:$HOME/flutter/bin"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/.emacs.d/bin"

[[ -s ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -s ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -s ~/.functions ]] && source ~/.functions
[[ -s ~/.extra ]] && source ~/.extra

[[ $TERM == *"rxvt"* ]] && wmctrl -r :ACTIVE: -b add,fullscreen
