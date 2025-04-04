#!/bin/zsh

total_duration=0

# Find the maximum filename length
max_filename_length=0
for f in "$1"/*.*; do
  filename=$(basename "$f")
  filename_length=${#filename}
  if (( filename_length > max_filename_length )); then
    max_filename_length=$filename_length
  fi
done

# Calculate the number of tabs needed for spacing
tabs_needed=$(( (max_filename_length + 7) / 8 ))
tabs=$(printf '\t%.0s' {1..$tabs_needed})
printf "%-${max_filename_length}s\t%s\t%s\t%s\t%s\n" "Filename" "Min" "Res" "FPS" "Mbps"


for f in "$1"/*.*; do
  filename=$(basename "$f")
  duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$f" | awk '{printf "%.1f", $1/60}')
  total_duration=$(( total_duration + duration ))
  resolution=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$f")
  framerate=$(ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of default=noprint_wrappers=1:nokey=1 "$f" | awk -F'/' '{if (NF==2) printf "%.0f", $1/$2; else print $1}')
  bitrate=$(ffprobe -v error -show_entries format=bit_rate -of default=noprint_wrappers=1:nokey=1 "$f" 2>/dev/null || echo "N/A")
  if [[ "$bitrate" != "N/A" ]]; then
    bitrate=$(awk '{printf "%.0f", $1/1000000}' <<< "$bitrate")
  fi

  # Print the data with dynamic spacing
  printf "%-${max_filename_length}s\t%s\t%s\t%s\t%s\n" "$filename" "$duration" "$resolution" "$framerate" "$bitrate"
done | column -t -s $'\t'

total_duration_minutes=$(awk '{printf "%.1f", $1}' <<< "$total_duration")
total_duration_hours=$(awk '{printf "%.1f", $1/60}' <<< "$total_duration")

printf "\nTotal duration: %.0f minutes (%.1f hours)\n" "$total_duration_minutes" "$total_duration_hours"
