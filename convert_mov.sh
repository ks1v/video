#!/bin/bash

# Loop through each MOV file in the directory
for file in *.MOV; do
    # Extract the creation date and time from the EXIF data
    datetime=$(exiftool -CreateDate -d "%Y-%m-%d_%H-%M-%S" "$file" | awk -F': ' '{print $2}')    
    # If datetime is not empty, proceed with conversion and renaming
    if [ ! -z "$datetime" ]; then
        # Create the new MP4 filename using the extracted datetime
        newname="${datetime}.mp4"
        
        # Use ffmpeg to copy streams and change container format to MP4
        ffmpeg -i "$file" -c copy "$newname"
        
        # Check if the conversion was successful before removing the original file
        if [ $? -eq 0 ]; then
            rm "$file"
        else
            echo "Error converting $file"
        fi
    else
        echo "No DateTimeOriginal found for $file"
    fi
done
