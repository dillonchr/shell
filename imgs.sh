#!/usr/bin/env bash

png2webp () {
  local count=0
  local quality="${1:-85}"
  local converter=""

  if command -v cwebp >/dev/null 2>&1; then
    converter="cwebp"
  elif command -v magick >/dev/null 2>&1; then
    converter="magick"
  elif command -v convert >/dev/null 2>&1; then
    converter="convert"
  else
    echo "Error: No WebP conversion tool found (install cwebp or imagemagick)." >&2
    return 1
  fi

  while IFS= read -r -d '' file; do
    local out_file="${file%.png}.webp"
    local status=0

    case "$converter" in
      cwebp)
        cwebp -q "$quality" "$file" -o "$out_file" >/dev/null 2>&1
        status=$?
        ;;
      magick)
        magick "$file" -quality "$quality" "$out_file"
        status=$?
        ;;
      convert)
        convert "$file" -quality "$quality" "$out_file"
        status=$?
        ;;
    esac

    if (( status != 0 )); then
      echo "Failed to convert: $file" >&2
      return 1
    fi

    rm "$file"
    ((count++))
  done < <(find . -type f -name "*.png" -print0)

  if command -v textbanner >/dev/null 2>&1; then
    textbanner "webp'd $count file(s)"
  else
    echo "webp'd $count file(s)"
  fi
}

