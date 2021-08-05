#!/bin/bash

cleanupenrolldocs () {
  find ~/Downloads -maxdepth 1\
    -name 'master*.pdf' \
    -o -name 'gsd*.pdf' \
    -o -name 'plans*.pdf' \
    -o -name 'rates*.pdf' \
    -o -name 'account*.pdf' \
    -o -name 'census*.xlsx' \
    -o -name 'AWB.secret*.txt' \
    -o -name 'dental*.xlsx' \
    -o -name 'eft*.pdf' \
    -o -name 'initials*.pdf' \
    -o -name 'paperless*.pdf' \
    -o -name 'participation-agreement*.pdf' \
    -o -name 'signature*.pdf' \
    -o -name 'cobra-admin*.pdf' \
    -o -name 'cobra-appendix*.pdf' \
    -o -name 'cobra-cover*.pdf' \
    -o -name 'cobra-hipaa*.pdf' \
    -o -name 'eap*.pdf' \
    -o -name 'shop-request*.pdf' | xargs rm
}

wemake () {
  BOUNCE=$1
  version=dev make -C ~/work/Wired-Enroll
  if [ "$?" -ne "0" ]
  then
    echo "🤯 client broke!"
    return 1
  fi

  version=dev make -C ~/work/Wired-Enroll-Server
  if [ "$?" -ne "0" ]
  then
    echo "🤬 server broke!"
    return 2
  fi

  if [ "$BOUNCE" = "fetchers" ]; then
    bouncefetchers
    echo " 🤺 ready Freddie"
  elif [ "$BOUNCE" = "server" ]; then
    bounceserver
    echo " 🤓 it's ALIVE"
  elif [ "$BOUNCE" = "all" ]; then
    bounceserver
    bouncefetchers
    echo " 🌀 have a nice day"
  else
    echo " 🤙 party on dudes"
  fi
}

bounceserver () {
  docker exec we-server bash -c "source ~/.bashrc && cd /opt/apps/enroll && script/spin around"
}

bouncefetchers () {
  docker exec we-server bash -c "source ~/.bashrc && cd /opt/apps/enroll && script/fetcher_cluster restart"
}

# update all current branches and rebuild and bounce fetchers
upup () {
  dirs -c
  pushd ~/work/Wired-Enroll
  git fetch -p
  git pull
  git pull origin master
  popd
  pushd ~/work/Wired-Enroll-Server
  git fetch -p
  git pull
  git pull origin master
  popd
  pushd ~/work/Wired-Quote
  git fetch -p
  git pull
  git pull origin master
  popd
  wemake fetchers
}
