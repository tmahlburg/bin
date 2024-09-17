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

pid="$(swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true) | .pid')"

if is_floating ; then
	swaymsg floating disable
	swaymsg [pid="$pid"] shadows disable
else
	swaymsg floating enable
	swaymsg [pid="$pid"] shadows enable
fi
