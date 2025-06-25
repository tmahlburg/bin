#!/bin/sh
#
# dependencies: ImageMagick
# license: CC0
# author: Till Mahlburg

usage () {
	cat <<- EOF
usage: $(basename "$0") <background tile> <foreground image> <target resolution> [output]

Takes the background tile and tiles it to fill up the target resolution. It then imposes the foreground image on top. Uses ImageMagick.
EOF
}

build_tiles () {
	local tile
	tile="$1"
	local res
	res="$2"

	if ! magick -size "$res" tile:"$tile" "wp_tile.png" ; then
		exit 1
	fi
}

combine () {
	local bg
	bg="$1"
	local fg
	fg="$2"
	local out
	out="$3"

	if ! magick composite "$fg" "$bg" -colorspace sRGB -gravity center "${out:-wp_combined.png}" ; then
		exit 1
	fi
}

if test -z "$3" ; then
	usage
	exit 1
fi
build_tiles "$1" "$3"
combine wp_tile.png "$2" "$4"
