#!/bin/sh
#
# depends: sway, jq
#
# enables shadows for floating windows and disables them
# for non-floating windows
#
# author: Till Mahlburg
# license: CC0

is_floating () {
	local window_type
	window_type="$(swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true) | .type')"

	if [ "$window_type" = "\"floating_con\"" ] ; then
		return 0
	fi
	return 1
}

if is_floating ; then
	swaymsg floating disable
	swaymsg shadows disable
	swaymsg border pixel 1
	swaymsg floating_border pixel 1
else
	swaymsg floating enable
	swaymsg shadows enable
	swaymsg border normal 1
	swaymsg floating_border normal 1
	swaymsg move position cursor
fi
