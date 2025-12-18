#!/bin/bash

regenceappts () {
  if [ "$#" -ne 2 ]; then
    echo "Requires 2 params, the paths to the sheets."
    return 1
  fi

  OR="$1"
  WA="$2"

  textbanner "Regence Appointments, hooray! $(ts)"
  pushd ~/Development/wired-config
  mv "$OR" build/script/regence_agents/or-cc-appointed.xlsx
  mv "$WA" build/script/regence_agents/wa-asuris-appointed.xlsx
  ./build/script/regence_agents/update_regence_agents.sh
  textbanner "COCE ALERT!"
  echo
  echo "You have to be sure that you try applying the sql locally before pushing."
  echo "cat build/script/regence_agents/agent_updates.sql | pbcopy"
  cat build/script/regence_agents/agent_updates.sql | pbcopy
  open "http://localhost:8080/"
}

kpwaappts () {
  if [ "$#" -ne 1 ]; then
    echo "Requires 1 param, the path to KPWA sheet."
    return 1
  fi

  WA="$1"

  textbanner "KPWA $(ts)"
  pushd ~/Development/wired-config
  mv "$WA" build/script/kaiser_agents/kpwa-appointed.xlsx
  ./build/script/kaiser_agents/update_kaiser_agents.sh
}

kporappts () {
  if [ "$#" -ne 1 ]; then
    echo "Requires 1 param, the path to KPOR sheet."
    return 1
  fi

  OR="$1"

  textbanner "KPOR $(ts)"
  pushd ~/Development/wired-config
  mv "$OR" build/script/kaiser_agents/kpor-appointed.xlsx
  ./build/script/kaiser_agents/update_kaiser_agents.sh
}

uhcappts () {
  if [ "$#" -ne 1 ]; then
    echo "Requires 1 param, the path to UHC sheet."
    return 1
  fi

  WA="$1"

  textbanner "UHC $(ts)"
  pushd ~/Development/wired-config
  mv "$WA" build/script/uhc_agents/uhc-appointed.xlsx
  ./build/script/uhc_agents/update_uhc_agents.sh
}

connexionappts () {
  if [ "$#" -ne 1 ]
  then
    echo "Requires 1 param, the path to the CONNEXION sheet."
    return 1
  fi
  WA="$1"
  textbanner "Connexion $(ts)"
  pushd ~/Development/wired-config
  node build/script/connexion_agents/translate_sheet_to_json.js "$WA" | head -n 50
  echo "Look good? [yn]"
  read answer
  case "$answer" in
    [nN]* ) echo "Okay, stopping short."
      ;;
    *) doconnexionapps "$WA"
      ;;
  esac
}

doconnexionapps () {
  pushd ~/Development/wired-config
  mv "$1" build/script/connexion_agents/connexion-appointed.xlsx
  ./build/script/connexion_agents/update_connexion_agents.sh
}
