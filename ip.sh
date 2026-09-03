#!/usr/bin/env bash

ip () {
  local target="${1:-}"
  local response

  response="$(curl -fsSL "http://ip-api.com/json/${target}?fields=country,regionName,city,timezone,zip,isp,org,query,status,message" 2>/dev/null)"
  if [[ -z "$response" ]]; then
    echo "Error: Failed to fetch IP information" >&2
    return 1
  fi

  if command -v jq >/dev/null 2>&1; then
    echo "$response" | jq .
  elif command -v python3 >/dev/null 2>&1; then
    echo "$response" | python3 -m json.tool
  elif command -v python >/dev/null 2>&1; then
    echo "$response" | python -m json.tool
  else
    echo "$response"
  fi
}

