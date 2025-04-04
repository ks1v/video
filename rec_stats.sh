#!/bin/zsh

total_duration=0
max_filename_length=0
for f in "$1"/*.*; do
  filename=$(basename "$f")
  filename_length=${#filename}
  if (( filename_length > max_filename_length )); then
    max_filename_length=$filename_length
  fi
done

tabs_needed=$(( (max_filename_length + 7) / 8 ))
tabs=$(printf '\t%.0s' {1..$tabs_needed})
printf "%-${max_filename_length}s\t%s\t%s\t%s\t%s\n" "Filename" "Min" "Res" "FPS" "Mbps"

for f in "$1"/*.*; do
  filename=$(basename "$f")
  duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$f")
  duration_min=$(awk '{printf "%.1f", $1/60}' <<< "$duration")
  resolution=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$f")
  framerate=$(ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of default=noprint_wrappers=1:nokey=1 "$f" | awk -F'/' '{if (NF==2) printf "%.0f", $1/$2; else print $1}')
  bitrate=$(ffprobe -v error -show_entries format=bit_rate -of default=noprint_wrappers=1:nokey=1 "$f" 2>/dev/null || echo "N/A")
  if [[ "$bitrate" != "N/A" ]]; then
    bitrate=$(awk '{printf "%.0f", $1/1000000}' <<< "$bitrate")
  fi

  printf "%-${max_filename_length}s\t%s\t%s\t%s\t%s\n" "$filename" "$duration_min" "$resolution" "$framerate" "$bitrate"
done | column -t -s $'\t'