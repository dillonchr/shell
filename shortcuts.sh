#!/bin/bash

# use venv already
vvv () {
  if [[ ! -d venv ]]
  then
    python3 -m venv venv
  fi

  source venv/bin/activate
}

# my insane search
ggg () {
  grep -rEnoi --exclude-dir={node_modules,.next,.sass-cache,.git,Pods,build,public,__pycache__,tmp,db,test,.idea,.gems,spec,vendor,log,coverage,data,cache,packs,packs-test,./src/app/} ".{0,10}$1.{0,10}" .
}

# generate some lorem text
lorem () {
  LINES=$1
  if [ -z "$LINES" ]; then
    LINES=20
  fi
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

# probably don't need this anymore, but how macos gets nproc
nproc () {
  sysctl -n hw.physicalcpu
}
