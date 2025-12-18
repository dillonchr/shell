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
  git diff -b <(pdffields "$1") <(pdffields "$2")
}
