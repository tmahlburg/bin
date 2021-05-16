#!/bin/sh

##  @@@        @@@@@@    @@@@@@@  @@@  @@@  ##
##  @@@       @@@@@@@@  @@@@@@@@  @@@  @@@  ##
##  @@!       @@!  @@@  !@@       @@!  !@@  ##
##  !@!       !@!  @!@  !@!       !@!  @!!  ##
##  @!!       @!@  !@!  !@!       @!@@!@!   ##
##  !!!       !@!  !!!  !!!       !!@!!!    ##
##  !!:       !!:  !!!  :!!       !!: :!!   ##
##   :!:      :!:  !:!  :!:       :!:  !:!  ##
##   :: ::::  ::::: ::   ::: :::   ::  :::  ##
##  : :: : :   : :  :    :: :: :   :   :::  ##

## Locks your screen with a pixelized screenshot. Need i3lock
## Author: Till Mahlburg
## License: CC0

rm -f /tmp/screen_blurred.png

grim /tmp/screen.png

ffmpeg -loglevel error -hide_banner -nostats -i /tmp/screen.png -vf "boxblur=6:5, eq=brightness=-0.3" /tmp/screen_blurred.png

rm -f /tmp/screen.png

ffmpeg -loglevel error -hide_banner -nostats -i /tmp/screen_blurred.png -i $HOME/img/wp/lock_screen_overlay.png -filter_complex "[0:v][1:v] overlay" /tmp/screen.png

swaylock -f -e -i /tmp/screen.png
