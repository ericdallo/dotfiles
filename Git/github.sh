#!/bin/bash
github() {
  giturl=$(git config --get remote.origin.url)
  if [ "$giturl" == "" ]
    then
     echo "Esta pasta nao e um repositorio git ou nao esta setado o 'remote.origin.url'"
     exit 1;
  fi
 
  giturl=${giturl/git\@github\.com\:/https://github.com/}
  giturl=${giturl/\.git/\/tree/}
  branch="$(git symbolic-ref HEAD 2>/dev/null)" ||
  branch="(unnamed branch)"     # detached da HEAD
  branch=${branch##refs/heads/}
  giturl=$giturl$branch
  xdg-open $giturl
}


github
