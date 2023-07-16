#!/bin/bash

set -Eeuo pipefail

in=$1
# Force .png because JPEG doesn't support alpha channel
out=${2:-$(sed -E 's/(\.[^.]+)$/.circle.png/' <<<"$1")}

x_radius=$(identify -format %w "$in" | awk '{print $1/2}')
y_radius=$(identify -format %h "$in" | awk '{print $1/2}')

convert "$in" \( \
  +clone -threshold -1 -negate -fill white \
  -draw "ellipse $x_radius, $y_radius $x_radius, $y_radius 0, 360" \
  \) \
  -alpha Off -compose copy_opacity -composite "$out"

if [[ -z ${2:-} ]]; then
  echo "$out"
fi
