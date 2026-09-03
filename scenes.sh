#!/usr/bin/env bash

scenes () {
  local source="$1"
  local threshold="${2:-0.4}"
  local ts_file
  local movie_timestamp

  if [[ -z "$source" || ! -f "$source" ]]; then
    echo "Usage: scenes <video-file> [threshold]" >&2
    return 1
  fi

  if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "Error: ffmpeg is required but not installed." >&2
    return 1
  fi

  ts_file="$(mktemp /tmp/scenes_timestamps.XXXXXX)"
  ffmpeg -i "$source" -filter:v "select='gt(scene,${threshold})',showinfo" -f null - 2> "$ts_file"

  while IFS= read -r movie_timestamp; do
    [[ -z "$movie_timestamp" ]] && continue
    ffmpeg -ss "$movie_timestamp" -i "$source" -vframes 1 -q:v 5 "t_${movie_timestamp}.jpg"
  done < <(grep showinfo "$ts_file" | grep -o 'pts_time:[0-9.]*' | grep -o '[0-9]*\.[0-9]*')

  rm -f "$ts_file"
}
