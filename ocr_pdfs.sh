#! /bin/sh

#####################################################
# Name: ocr_pdfs.sh
#
# <Description>
#
# Usage:
#
# Origin:
# License:
#
# Version: 0.1
# Author: tillm
# Date of Creation: 2023-12-19
######################################################

# Functions

usage () {
cat <<- EOF
usage: $(basename "$0") -h

<command description>

OPTIONS:
    -h shows this help
EOF
}

is_pdf () {
	local file
	file="$1"
	file "$file" | grep -q "PDF"
}

has_text () {
	local file
	file="$1"
	grep -aq /Text "$file"
}

ocr () {
	local file
	file="$1"
	pdfsandwich "$file"
}

# Main functionality. Evaluates the given arguments.

main () {
    while getopts "h" opt; do
        case $opt in
            h )     usage ;;
            \? )    usage
                    exit 1 ;;
            esac
    done
    shift $((OPTIND - 1))

	local file
	file="$1"

	if ! is_pdf "$file" || has_text "$file" ; then
		echo "skipping $file"
	else
		echo "else"
		ocr "$file"
	fi
}
main "$@"
