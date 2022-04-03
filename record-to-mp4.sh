#!/usr/bin/env bash

# Make a really low effort attempt to not clobber shit
# you can pass in -f before the name of the screencast
# if you'd like to just reprocess everything.

while getopts "f" flag; do
case "$flag" in
    f) FORCE=FORCE;;
esac
done
shift $(($OPTIND - 1))

if [ "x${1}" = "x" ]; then
    echo "Need a base name for the recording"
    exit 1
fi

if [ "x${FORCE}" != "xFORCE" ]; then
    if [ -f "${1}" ]; then
        echo "The name ${1} is already in use, try again"
        exit 1
    fi

    if [ -d "${1}" ]; then
        echo "The name ${1} is already in use, try again"
        exit 1
    fi
fi

CAST_BASE="${1}"
OUT_CAST="${CAST_BASE}.asciicast"
OUT_MP4="${CAST_BASE}.mp4"

FF_IN_FRAMERATE=${FF_IN_FRAMERATE:-"8"}
INK_DPI=${INK_DPI:-"300"}
FF_ENCODER=${FF_ENCODER:-"libx264"}
FF_PIXFMT=${FF_PIXFMT:-"yuv420p"}

INKSCAPE=$(which inkscape)
INKSCAPE=${INKSCAPE:-"/Applications/Inkscape.app/Contents/MacOS/inkscape"}

for i in "${CAST_BASE}"/termtosvg_*.svg; do
  ./transform.rb "${i}"
done

# This is expected to spit out lots of warnings.
"${INKSCAPE}" --export-type="png" --export-dpi="${INK_DPI}" "${CAST_BASE}"/update-*.svg

ffmpeg -hide_banner -framerate "${FF_IN_FRAMERATE}" -i "${CAST_BASE}/update-%05d.png" -c:v "${FF_ENCODER}" -r 30 -pix_fmt "${FF_PIXFMT}" "${OUT_MP4}"

echo
echo
echo
echo "Final output: ${OUT_MP4}"

ffprobe -hide_banner "${OUT_MP4}"
