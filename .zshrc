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

_bb_tasks() {
    local matches=(`bb tasks |tail -n +3 |cut -f1 -d ' '`)
    compadd -a matches
    _files # autocomplete filenames as well
}
compdef _bb_tasks bb

ssh-add ~/.ssh/github > /dev/null
