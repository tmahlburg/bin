#! /bin/sh

#####################################################
# Name: plumb.sh
#
# Simple script piping th current selection to
# xdg-open
#
# Usage: plumb.sh
#
# License: GPLv3
#
# Version: 0.1
# Author: Till Mahlburg
# Date of Creation: 2021-05-11
######################################################

# Variables
RUN_COMMAND="xdg-open"
PASTE_COMMAND="wl-paste -p"

# Functions

# Main functionality. Evaluates the given arguments.

main () {
	local selection
	selection="$($PASTE_COMMAND)"
	$RUN_COMMAND $selection
}
main "$@"
