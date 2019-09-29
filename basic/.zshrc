source ~/.critical-keys

export EDITOR=vim
export PI=192.168.1.108

# Path to your oh-my-zsh installation.
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
export NIX_PATH="$HOME/bin:/run/wrappers/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
export PATH="$PATH:$NIX_PATH"
export PATH="$PATH:$HOME/.vimpkg/bin"
export PATH="$PATH:$HOME/.emacs.d/bin"
export PATH="$PATH:$HOME/.rvm/bin"
export ZSH=/home/$USERNAME/.oh-my-zsh
export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_102
export JAVA7_HOME=/usr/lib/jvm/jdk1.7.0_79
export GRADLE_OPTS=-Xmx1024m
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/bin:$PATH

ZSH_THEME="simple"

plugins=(git kubectl)

source $ZSH/oh-my-zsh.sh
source /usr/local/share/chruby/chruby.sh

[[ -s ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -s ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -s ~/.functions ]] && source ~/.functions

if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi

source "$HOME/.sdkman/bin/sdkman-init.sh"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/greg/.sdkman"
[[ -s "/home/greg/.sdkman/bin/sdkman-init.sh" ]] && source "/home/greg/.sdkman/bin/sdkman-init.sh"

