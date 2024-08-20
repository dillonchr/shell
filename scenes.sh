#!/bin/bash

SOURCE="$1"
TS_FILE=/tmp/raw_timestamps
ffmpeg -i "$SOURCE" -filter:v "select='gt(scene,0.4)',showinfo" -f null - 2> $TS_FILE
TIMES=$(grep showinfo $TS_FILE | grep 'pts_time:[0-9.]*' -o | grep '[0-9]*\.[0-9]*' -o)

for movie_timestamp in $TIMES
do
  ffmpeg -ss "$movie_timestamp" -i "$SOURCE" -vframes 1 -q:v 5 "t_${movie_timestamp}.jpg"
done
