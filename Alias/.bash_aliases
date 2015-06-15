#alias media='cd /home/eric/github/media && ls -a'
#alias upmedia='media && git add . && git commit -m "" && git push'
alias goo='cd /home/eric/Google\ Drive/ && ls'

alias killmux='tmux kill-window -a && exit'


alias ll='ls -l'

alias pl="ps aux | grep"
alias killtomcat="pl [t]omcat | awk '{print \$2}' | xargs kill -9"
alias tunnel="ssh -N -R 8100:localhost:8080 -i ~/dev/keys/integration.pem ec2-user@integration.elo7.com.br"
alias elo7.log="tail -f -n 1000 /var/log/elo7/elo7.log"
alias marketplace="tmuxinator start marketplace"

alias u="cd ../"
alias uu="cd ../../"
alias uuu="cd ../../../"
alias uuuu="cd ../../../../"
alias uuuuu="cd ../../../../../"

# Bundler
alias b="bundle"
alias bi="b install --path vendor"
alias bu="b update"
alias be="b exec"
alias binit="bi && b package && echo 'vendor/ruby' >> .gitignore"


alias sshu="ssh -i ~/dev/keys/production_new.pem -l ubuntu"
alias sshc="ssh -i ~/dev/keys/production_new.pem -l core"
alias sshi="ssh -i ~/dev/keys/integration.pem -l ec2-user"
alias sshpn="ssh -i ~/dev/keys/production.pem -l ec2-user"
alias sshnat="ssh -i ~/dev/keys/production_new.pem -l ec2-user"

V3=~/dev/marketplace/elo7/src/main/webapp/v3
alias rm.assets="rm -rf $V3/common/css && rm -rf $V3/mobile/css && rm -rf $V3/desktop/css && rm -f $V3/common/js/elo7.js && rm -f $V3/mobile/js/mobile.js && rm -f $V3/desktop/js/desktop.js"
alias wtf="rm.assets; killtomcat; mvn clean eclipse:clean eclipse:eclipse -Dwtpversion=2.0"

alias rehash="source ~/.bash_profile"

# Allows to override Same-Origin policy
alias ogc='open -a Google\ Chrome --args --disable-web-security'

# Runs grunt in dev
alias dev='cd /Users/Developer/dev/marketplace/elo7/grunt && ./node_modules/grunt-cli/bin/grunt --gruntfile=gruntfiles/dev.js --base=.'

alias update-dummy="mysqldump -u root -d elo7 | mysql -u root -Delo7_dummy"
alias run-all-tests="mvn clean test -P run-all-tests"
alias run-migration="flyway-migration"
alias curl_api="~/dev/dotfiles/scripts/marketplace/mobile/curl_api.sh"
alias i18n="~/dev/dotfiles/scripts/marketplace/i18n/elo7locale.sh"
