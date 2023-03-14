#!/bin/bash

png2webp () {
  i=0
  find . -type f -name "*.png" -print0 | while read -d $'\0' file
  do
    convert "$file" -quality 85 "${file%.png}.webp"
    ((i=i+1))
    if [ "$?" -ne "0" ]; then
      echo "$file broke everything!"
      exit 1
    fi
    rm "$file"
  done
  textbanner "webp'd $i file(s)"
}

