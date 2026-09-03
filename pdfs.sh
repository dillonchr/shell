#!/usr/bin/env bash

pdffields () {
  local pdf_path="$1"
  if [[ -z "$pdf_path" || ! -f "$pdf_path" ]]; then
    echo "Usage: pdffields <path-to-pdf>" >&2
    return 1
  fi
  if ! command -v pdftk >/dev/null 2>&1; then
    echo "Error: pdftk is required but not installed." >&2
    return 1
  fi
  pdftk "$pdf_path" dump_data_fields | awk -F ': ' '/^FieldName: /{print $2}' | sort
}

searchfields () {
  local pdf_path="$1"
  local line
  if [[ -z "$pdf_path" || ! -f "$pdf_path" ]]; then
    echo "Can't find file: $pdf_path" >&2
    return 1
  fi

  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    if ! ggg "$line" >/dev/null 2>&1; then
      echo "$line"
    fi
  done < <(pdffields "$pdf_path" | grep "-" | sed "/-\(yes\|no\)$/d" | sed "s/-/\./g")
}

diffforms () {
  if [[ -z "$1" || -z "$2" || ! -f "$1" || ! -f "$2" ]]; then
    echo "Usage: diffforms <pdf1> <pdf2>" >&2
    return 1
  fi
  git diff -b <(pdffields "$1") <(pdffields "$2")
}
