#!/bin/sh
#
# author: Till Mahlburg
# license: CC0
#

if pgrep sway ; then
	swaymsg exec "vivaldi-stable --new-window netflix.com"
	sleep 2
	wlrctl toplevel focus title:"Netflix - Vivaldi"
	wtype -M ctrl -k F11 -m ctrl
	swaymsg floating enable
	sleep 1
	wlrctl toplevel focus title:"Netflix - Vivaldi"
	swaymsg resize set 640 px 360 px
	swaymsg sticky enable
else
	echo "sway isn't running"
fi
