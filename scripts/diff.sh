#!/bin/bash

set -Eeuo pipefail

margin=${margin:-200}

before=${1:-before.png}
after=${2:-after.png}
diff=${3:-diff.png} # When uploaded as 'diff.apng', Slack didn't show thumbnail :(
format=${4:-apng}

file "$before" "$after"

tmp=$(mktemp -d)
if magick compare "$before" "$after" -compose src "$tmp"/diff.png; then
    echo no diff
    exit
fi

# Get diff area
read img_width img_height diff_width diff_height diff_top < <(
    convert "$tmp"/diff.png -verbose -trim /dev/null |
        grep -F '=>' |
        sed -e 's/.* \([0-9]*\)x\([0-9]*\)=>\([0-9]*\)x\([0-9]*\) [0-9]*x[0-9]*+[0-9]*+\([0-9]*\).*/\1 \2 \3 \4 \5/'
)
((diff_bottom = diff_top + diff_height))
((crop_top = diff_top > margin ? diff_top - margin : 0))
((crop_bottom = diff_bottom + margin > img_height ? img_height : diff_bottom + margin))
((crop_height = crop_bottom - crop_top))
((text_top = crop_top + 30))

# TODO: diffがめちゃくちゃ上の方にある場合、文字がかぶるので余白をつけたい

# Crop each image and add text
function crop_and_caption() {
    # Thanks to https://legacy.imagemagick.org/discourse-server/viewtopic.php?t=31323
    convert "$1" \
        \( -size "$img_width"x"$crop_height" -background none -gravity center -pointsize 50 -fill white caption:"$2" -trim +repage \) \
        \( -clone 1 -background black -shadow 80x3+2+2 \) \
        \( -clone 1 -clone 2 +swap -background none -layers merge +repage \) \
        -delete 1,2 +gravity -geometry +30+"$text_top" -compose over -composite \
        -crop "$img_width"x"$crop_height"+0+"$crop_top" \
        "$tmp"/"$3".png
}

crop_and_caption "$before" Before 0
crop_and_caption "$after" After 1

# Animate images
ffmpeg -hide_banner -loglevel warning -y -r 1 -i "$tmp"/%d.png -r 2 -plays 0 -f "$format" "$diff"

file "$diff"
rm -rf "$tmp"
