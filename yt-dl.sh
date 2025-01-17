
#"https://www.youtube.com/@%D1%80%D0%BE%D0%B4%D0%B8%D0%BD%D0%B0-%D0%BB4%D0%BE"
#"https://www.youtube.com/@stropov"
#"https://www.youtube.com/@thepartyofthedead"
# https://www.youtube.com/@Mdvzhnk
# https://www.youtube.com/@LazySquare
# https://www.youtube.com/@Drugslab
# https://www.youtube.com/@LazySquare


url="https://www.youtube.com/@LazySquare"
stage=~/Stage/ytdlp/LazySquare
log=~/ytdlp/yt-dlp.log

mkdir -p $stage
touch $log

common_opts=(
    --cookies-from-browser firefox
#    --format 'bestvideo+bestaudio/best'
    --format "(bv*[vcodec~='^(avc1|avc|h264)']+ba[acodec~='^(m4a|aac)']) / (bv*+ba/b)"
#    --recode-video mp4
    --embed-subs
    --write-subs
    --embed-metadata
    --postprocessor-args "-crf 19 -hide_banner -threads 4"
    --download-archive "$log"
#    --simulate
)


yt-dlp "${common_opts[@]}" \
    --yes-playlist \
    --output "$stage/%(playlist_title)s/%(upload_date)s %(title)s [%(id)s].%(ext)s" \
    "$url/playlists"


yt-dlp "${common_opts[@]}" \
    --output "$stage/videos/%(upload_date)s %(title)s [%(id)s].%(ext)s" \
    "$url"

echo "END"
