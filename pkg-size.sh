#!/usr/bin/env bash

pkgSize () {
  local pkg="$1"
  if [[ -z "$pkg" ]]; then
    echo "Usage: pkgSize <package-name>" >&2
    return 1
  fi

  local response
  response="$(curl -fsSL "https://packagephobia.com/v2/api.json?p=${pkg}" 2>/dev/null)"
  if [[ -z "$response" ]]; then
    echo "Error: Failed to fetch package size for '$pkg'" >&2
    return 1
  fi

  if command -v jq >/dev/null 2>&1; then
    echo "$response" | jq .
  elif command -v python3 >/dev/null 2>&1; then
    echo "$response" | python3 -m json.tool
  else
    echo "$response"
  fi
}

alias pkgsize='pkgSize'
