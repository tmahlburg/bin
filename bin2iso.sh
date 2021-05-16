#! /bin/sh

#####################################################
# Name: bin2iso.sh
#
# Converts .bin and .cue files with the same name to
# iso using bchunk.
#
# Usage: bin2iso.sh <file name without extension>
#
# License: GPLv3
#
# Version: 0.1
# Author: Till Mahlburg
# Date of Creation: 2020-05-27
######################################################

# Functions

usage () {
cat <<- EOF
usage: $(basename "$0") <file name without extension> [-h] [-a]

INFO:
	The bin and the cue file should have the same name, except for the extension itself (.bin / .cue). The output file is going to have the same name.

OPTIONS:
	-a runs it for all bin files in the current dir
    -h shows this help
EOF
}

convert_all () {
	for file in *.cue ; do
		conversion "$(basename "$file" .cue)"
	done
}

conversion () {
	local filename
	filename="$1"
	bchunk "$filename".bin "$filename".cue "$filename"
}

# Main functionality. Evaluates the given arguments.

main () {
    while getopts "ha" opt; do
        case $opt in
            h )     usage ;;
            a )		convert_all ;;
            \? )    conversion "$1" ;;
            esac
    done
    shift $((OPTIND - 1))
}
main "$@"
