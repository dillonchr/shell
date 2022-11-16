#!/bin/bash

png2webp () {
  find . -type f -name "*.png" -print0 | while read -d $'\0' file
  do
    convert "$file" -quality 85 "${file%.png}.webp"
    if [ "$?" -ne "0" ]; then
      echo "$file broke everything!"
      exit 1
    fi
    rm "$file"
  done
  toilet -f pagga "ok"
}

