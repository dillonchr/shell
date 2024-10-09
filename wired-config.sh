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
