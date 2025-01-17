#!/bin/zsh

find ./ -type f ! -name '*.mp4' -exec ~/convert_to_mp4.sh {} \;
