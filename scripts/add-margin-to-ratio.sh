#!/bin/bash

set -Eeuo pipefail

in=$1
out=$2
width=$3
height=$4
background=${5:-white}

file "$in"

orig_width=$(magick "$in" -ping -format %w info:)
orig_height=$(magick "$in" -ping -format %h info:)
new_width=$(bc <<<"$orig_height * $width / $height")

if [ "$new_width" -gt "$orig_width" ]; then
    magick "$in" -gravity center -background "$background" -extent ${new_width}x${orig_height} "$out"
else
    new_height=$(bc <<<"$orig_width * $height / $width")
    magick "$in" -gravity center -background "$background" -extent ${orig_width}x${new_height} "$out"
fi

file "$out"
