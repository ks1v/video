#!/bin/zsh

convert_to_mp4() {
  local input_file="$1"
  local output_file="${input_file%.*}X.mp4"

  echo "$input_file"

  local video_codec=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$input_file")
  local audio_codec=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$input_file")
  local file_ext="${input_file##*.}"

  # Determine if conversion is needed
  if [[ "$video_codec" == "h264" || "$video_codec" == "hevc" ]] && [[ "$audio_codec" == "aac" ]] && [[ "$file_ext" == "mp4" ]]; then
    echo "    Skipped"
    return 3
  fi

  # Set conversion parameters
  local vc="copy"
  local ca="copy"

  if [[ "$video_codec" != "h264" && "$video_codec" != "hevc" ]]; then
    vc="libx264"
  fi

  if [[ "$audio_codec" != "aac" ]]; then
    ac="aac"
  fi

  echo "    $file_ext"
  echo "    $video_codec > $vc"  
  echo "    $audio_codec > $ac"  

  # Convert using FFmpeg
  # ffmpeg -i "$input_file" -map 0 -c:s mov_text -c:v "$vc" -c:a "$ca" -y -hide_banner -loglevel error "$output_file"

  # Check if conversion was successful
  if [[ $? -eq 0 ]]; then
    echo "    Success"
    #rm -f "$input_file" # Remove original file
    return 1
  else
    echo "    FAILED"
    return 2
  fi
}

convert_to_mp4 "$1"
