#!/bin/zsh

# Define the root directory
#ROOT="$HOME/Stage/ytdlp/drugslab"
ROOT="/Users/ks1v/Stage/ytdlp/drugslab/Drug Tests/webm"

# Function to extract codec information using ffprobe
extract_codecs() {
    local file="$1"
    
    # Extract video codec name (first video stream only)
    local video_codec=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$file")
    
    # Extract all audio codec names (for all audio streams)
    local audio_codecs=$(ffprobe -v error -select_streams a -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$file" | paste -sd "," -)

    # Extract video bitrate (first video stream only)
    local total_bitrate=$(ffprobe -v error -show_entries format=bit_rate -of default=noprint_wrappers=1:nokey=1 "$file")
    
    # Convert bitrate from bits to kilobits (divide by 1000), and handle missing values
    if [[ -z "$total_bitrate" || "$total_bitrate" -eq 0 ]]; then
        total_bitrate="N/A"
    else
        total_bitrate=$((total_bitrate/1000))  # Convert bits to kilobits
    fi

    # Print the relative path (truncated to 70 characters), video codec, and audio codecs list
    local relative_path=${file#$ROOT/}
    printf "%-15s\t%s\t%s\t%s\t%s\n" "${relative_path:0:15}" "${file##*.}" "$video_codec" "$total_bitrate" "$audio_codecs"
}

# Walk through all files in subfolders of ROOT
find "$ROOT" -type f | while read file; do
    extract_codecs "$file"
done



# for file in *.(mkv)(N); do echo "$file" && ffmpeg -i "$file" -map 0 -c copy -c:s mov_text -hide_banner -loglevel error -stats -movflags faststart+use_metadata_tags "${file%.*}.mp4"; done

# for file in *.(webm)(N); do echo "$file" && ffmpeg -i "$file" -map 0 -c:v libx264 -c:a aac -c:s mov_text -hide_banner -loglevel error -stats -movflags faststart+use_metadata_tags "${file%.*}.mp4"; done

# for file in *.(webm)(N); do echo "$file" && ffmpeg -i "$file" -map 0 -c:v h264_videotoolbox -b:v $((0.9*$(ffprobe -v error -show_entries format=bit_rate -of default=noprint_wrappers=1:nokey=1 "$file"))) -c:a aac -c:s mov_text -hide_banner -loglevel info -stats -movflags faststart+use_metadata_tags "${file%.*}.mp4"; done