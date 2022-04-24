plugins=(git sudo docker)

ZSH_THEME="simple"
source $ZSH/oh-my-zsh.sh

source ~/.critical-keys
source ~/.env

#export TERM="rxvt-unicode-256color"

### Extra paths

[[ -s ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -s ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -s ~/.functions ]] && source ~/.functions
[[ -s ~/.extra ]] && source ~/.extra
