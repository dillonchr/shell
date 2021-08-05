#!/bin/bash

pdffields () {
  PDFPATH=$1
  pdftk "$PDFPATH" dump_data_fields | grep -e "^FieldName: " | sed 's/FieldName: //' | sort
}

searchfields () {
  PDFPATH=$1
  if [ -f "$PDFPATH" ]; then
    for line in $(pdffields $PDFPATH | grep "-" | sed "/-\(yes\|no\)$/d" | sed "s/-/\./g"); do results=$(ggg $line); if [ $? -ne 0 ]; then echo $line; fi; done;
  else
    echo "Can't find $PDFPATH";
  fi
}


