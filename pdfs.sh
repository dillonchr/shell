#!/bin/bash

pdffields () {
  PDFPATH=$1
  pdftk "$PDFPATH" dump_data_fields | awk -F ': ' '/^FieldName: /{print $2}' | sort
}

searchfields () {
  PDFPATH=$1
  if [ -f "$PDFPATH" ]; then
    for line in $(pdffields $PDFPATH | grep "-" | sed "/-\(yes\|no\)$/d" | sed "s/-/\./g"); do results=$(ggg $line); if [ $? -ne 0 ]; then echo $line; fi; done;
  else
    echo "Can't find $PDFPATH";
  fi
}

diffforms () {
  PDFA=$(mktemp)
  PDFB=$(mktemp)
  if [ -f script/pdffields ];
  then
    script/pdffields "$1" > $PDFA
    script/pdffields "$2" > $PDFB
  else
    pdffields "$1" > $PDFA
    pdffields "$2" > $PDFB
  fi
  git diff -b $PDFA $PDFB
}
