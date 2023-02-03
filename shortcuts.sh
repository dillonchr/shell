#!/bin/bash

# whenever working with Python projects, I always name my venv "venv"
# after following along in the Mega Flask tutorial I believe. Anyway,
# the point is that I always use the same dir name and if I try to
# activate that venv in a given directory, I probably thought it ought to
# have the venv in the first place. So this tries to use the venv
# and will instantiate it if it doesn't exist yet.
vvv () {
  if [[ ! -d venv ]]
  then
    python3 -m venv venv
  fi

  source venv/bin/activate
}

# GREP is something I struggle at. So I wrote this a long time ago and gave
# myself plenty of context and ignored all the folders that have thrown me
# off the trail over the years. It ain't perfect but it's been great for me.
ggg () {
  if command -v toilet &> /dev/null
  then
    toilet -f pagga "gggrep:"
    toilet -f smmono9 "$1"
  fi
  grep -rEnoi --exclude-dir={./config/agencies,node_modules,.next,.sass-cache,.git,Pods,build,public,__pycache__,tmp,db,test,.idea,.gems,spec,vendor,log,coverage,data,cache,packs,packs-test,./src/app/} ".{0,10}$1.{0,10}" .
}

# generates n lines of text, defaults to 20 lines
lorem () {
  LINES=$1
  if [ -z "$LINES" ]; then
    LINES=20
  fi
  export LC_CTYPE=C
  tr -dc a-z1-4 </dev/urandom | tr 1-2 ' \n' | awk 'length==0 || length>50' | tr 3-4 ' ' | sed 's/^ *//' | cat -s | sed 's/ / /g' |fmt | head -n $LINES
}

# make sure dns is fresh
flushdns () {
  sudo killall -HUP mDNSResponder
}
alias -g cleardns="flushdns"

# go back to the beginning
gitroot () {
  cd $(git rev-parse --show-toplevel)
}

gitprune () {
  git fetch -p ; git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -d
}

# delete all local branches if you can
cleanbranches () {
  git branch -a --no-color | sed "/^  remotes\//d" | sed "/^*/d" | sed "/^  stage$/d" | xargs git branch -d
}

# pull latest and also merge masta
uu () {
  git fetch -p
  git pull
  git pull origin master
}

# probably don't need this anymore, but how macos gets nproc
nproc () {
  sysctl -n hw.physicalcpu
}

dearkitty () {
  KITTY_BASE=~/git/kitty ~/git/kitty/dearkitty
}
