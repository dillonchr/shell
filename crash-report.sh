#!/usr/bin/env bash

crashreport () {
  local target_dir="$HOME/Documents"
  local target_file="${target_dir}/$(date +"%Y-%m-%d_%H-%M").txt"

  mkdir -p "$target_dir"
  if command -v pbpaste >/dev/null 2>&1; then
    pbpaste > "$target_file"
    echo "Saved crash report to $target_file"
  else
    echo "Error: pbpaste not found" >&2
    return 1
  fi
}

