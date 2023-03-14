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
    -o -name 'combined*.pdf' \
    -o -name 'shop-request*.pdf' | xargs -I % sh -c 'rm "%";'
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
    if (( $(tput cols) > 85 ));
    then
      cat <<EOL
                                                                                E  E
                                               EEEEE                            E  E
                                             EEE   EEE                          E  E
W     W   WW  W   WWWWW    WWWWWW WWWW       E                                  E  E
WW   WW   W   W  WW   WW   W      WW WWWW    E              EE  EEEE            E  EE
 WW  W W WW   W  W   WWW   W       W    WWW  EE          EEEEE  EE EE   EEEE    E   E
  W W  WWW    W  WWWW      WWWWWW  WW     WW  EEEEEEE    E   E  E      EE  EEE   E  E
   WW   WW    W  W  WW      W       W      W  EEEEEEE    E   E  E      E     EE  E  E
   W     W   WW  W   WWW    W       W     WW  E          E   E  E      E      E  E  E
             W   W     W    WWWWWW  WWWWWW    E              E  E      EEEE  EE  E  E
                                    WW        EE        E                 EEEE   E  E
                                               EEEEEEEEEE
EOL
    else
      cat <<EOL
                 EEEEE
W           W  EE     EEEE
W     W     W  E         EEE
W     W    WW EE
WW    WW   W  E   EEEE
 WW  WWW  WW  EEEEE  E
  W  W W  W    EEEEEEE
  WW W W WW   EE
   W W WWW    E
   WWW  WW    EEEEE
                  EEEEEEEE
EOL
    fi
    echo " 🤙 party on dudes"
  fi
}

bounceserver () {
  docker exec we-server bash -c "source ~/.bashrc && cd /opt/apps/enroll && script/spin around"
}

bouncefetchers () {
  docker exec we-server bash -c "source ~/.bashrc && cd /opt/apps/enroll && script/fetcher_cluster restart"
}

makequote () {
  docker exec we-server bash -c "source ~/.bashrc && cd /opt/apps/benefits && make"
}

bouncequotefetchers () {
  docker exec we-server bash -c "source ~/.bashrc && cd /opt/apps/benefits && script/fetcher_cluster restart"
}

# update all current branches and rebuild and bounce fetchers
upup () {
  dirs -c
  pushd ~/work/Wired-Enroll
  git fetch -p
  uu
  popd
  pushd ~/work/Wired-Enroll-Server
  git fetch -p
  uu
  popd
  pushd ~/work/Wired-Quote
  git fetch -p
  uu
  popd
  wemake fetchers
}

newwidget () {
  GREEN='\033[1;32m'
  NORM='\033[m'
  echo "New widget eh? Easy peazy."
  echo -e "Create your new widget in ${GREEN}widgetView/newWidget.js${NORM}"
  read trash\?"[Press enter to continue]"
  echo -e "Import/export the new widget in ${GREEN}app/views/widgetView/index.js${NORM}"
  read trash\?"[Press enter to continue]"
  echo -e "Now define the widget-type in the enum in ${GREEN}app/message/index.js${NORM}"
  read trash\?"[Press enter to continue]"
  echo -e "Add the widget name to the classes used in ${GREEN}app/views/appView/index.js${NORM}"
  read trash\?"[Press enter to continue]"
  echo -e "Add the widget name to ${GREEN}app/views/widgetView/_style.scss${NORM}"
  read trash\?"[Press enter to continue]"
  echo -e "Finally, use the hyphenated shortcode in the ${GREEN}RfpCellsSpec${NORM} in the ruleset's index."
  echo "Congrats"
}

# start nodemon watching sign docs, it might lead to a 404 at first, but just you wait!
signdocs () {
  open -a Firefox "file:///Users/dillon/work/Wired-Enroll-Server/master.pdf"
   docker exec we-server bash -c "source ~/.bashrc; cd /opt/apps/enroll; npx nodemon -w script/sign-docs.sh --exec script/sign-docs.sh"
}

copynewbranchhash () {
  echo -e "\`$(git hist --no-color | head -n 1 | sed 's/:.*$//g')\`" | pbcopy
}

fixpackagelock () {
  git diff --name-only --diff-filter=U --relative | grep package-lock.json
  if [ "$?" -eq "0" ]
  then
    rm package-lock.json
    touch package-lock.json
  fi
}

stagemerge () {
  if [ -z "$(git status --porcelain)" ]; then
    FEATURE_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    git fetch -p
    git checkout stage
    git pull
    git merge $FEATURE_BRANCH && wemake && git push
  fi
}

blames () {
  FILE_TO_BLAME="$1"
  mkdir -p blames

  for h in $(git log --format="%h" "$FILE_TO_BLAME")
  do
    git show "${h}:${FILE_TO_BLAME}" > "blames/${h}.${FILE_TO_BLAME##*.}"
  done
}
