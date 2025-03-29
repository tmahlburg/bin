#!/bin/sh
## Arch Linux / Manjaro / Void Linux System Maintenance
## Usage: maintenance.sh [options]
## Options: -r  create a system maintenance report, needs no user input, no changes are made
##          -p  invoke package management related maintenance tasks, CHANGES ARE MADE, requires root, pacman-based and xbps only
##          -m  updates mirrors, might take a while, requires root and network, just for manjaro, netrunner and arch
##          -a  invokes everything
##          -h  shows this help
## Author: Till Mahlburg
## License: GPLv3

usage () {
	cat <<- EOF
        usage: $(basename $0) [options]

	Script to automate the maintenance tasks of an archlinux, manjaro or voidlinux installation.

	OPTIONS:
	    -r  create a system maintenance report, needs no user input, no changes are made
	    -p  invoke package management related maintenance tasks, CHANGES ARE MADE
	    -m  updates mirrors, might take a while
	    -a  invokes everything
	    -h  shows this help
	EOF
}

report () {
    local current_date
    current_date=$(date +%Y-%m-%d)
    local service_manager
    # check for systemd
    if [ -f /usr/bin/systemctl ]; then
        service_manager="systemd"
    # check for runit
    elif [ -f /usr/bin/sv ]; then
        service_manager="runit"
    else
        echo "Your service manager could not be identified. The corresponding parts will be skipped."
        echo ""
    fi
    local

    echo "****************************************"
    echo "* System Maintenance Report $current_date *"
    echo "****************************************"
    echo ""
    echo "failed services:"
    echo ""
    if [ "$service_manager" = "systemd" ]; then
        systemctl --failed
    elif [ "$service_manager" = "runit" ]; then
        sv status /var/service/* | grep fail
    else
        echo "skipped"
    fi
    echo ""
    echo "****************************************"
    echo "high priority errors:"
    echo ""
    if [ "$service_manager" = "systemd" ]; then
        journalctl -p 3 -xb --no-pager
    elif [ "$service_manager" = runit ]; then
        cat /var/log/socklog/errors/current
    else
        echo "skipped"
    fi
    echo ""
    echo "****************************************"
    echo "broken symlinks:"
    echo ""
    find /home -xtype l -print
    find /opt -xtype l -print
    find /root -xtype l -print
    find /usr -xtype l -print
    find /etc -xtype l -print
    find /var -xtype l -print
    if [ -e /usr/bin/pacman ]; then
        echo ""
        echo "****************************************"
        echo ".pacnew and .pacsave files:"
        echo ""
        find /etc -regextype posix-extended -regex ".+\.pac(new|save|orig)" 2> /dev/null
        if  command -v pmclean > /dev/null; then
			echo ""
        	echo "****************************************"
        	echo "Packages not required by any other package:"
        	echo ""
			pmclean
		fi
    fi
    if [ -e /usr/bin/xbps-install ]; then
        echo ""
        echo "****************************************"
        echo ".new files:"
        echo ""
        xdiff -l
        echo ""
        echo "****************************************"
        echo "broken packages:"
        echo ""
        xbps-pkgdb -a 2>&1
        echo ""
        echo "****************************************"
        echo "applications needing restarts:"
        echo ""
        xcheckrestart
        if  command -v indie_pkg > /dev/null; then
			echo ""
        	echo "****************************************"
        	echo "Packages not required by any other package:"
        	echo ""
			indie_pkg
		fi
    fi
}

packages () {
    echo "Cleaning package cache..."
    if [ -f /usr/bin/yay ]; then
	yay -Sc --noconfirm
    elif [ -f /usr/bin/pacaur ]; then
        pacaur -Sc --noconfirm
    elif [ -f /usr/bin/xbps-remove ]; then
        xbps-remove -O
    else
        pacman -Sc --noconfirm
    fi

    if [ -f /usr/bin/xbps-remove ]; then
        echo "Removing orphans..."
        xbps-remove -oy
    elif [ ! "$(pacman -Qtdq)" = "" ]; then
        echo "Removing orphans..."
        pacman -Rns $(pacman -Qtdq) --noconfirm
    fi
}


update_mirrorlist () {
	. "/etc/os-release"
    local os
    #os=$(uname -r)
    #os=${os#*-*-}
    os="$NAME"
	case $os in
        "Manjaro"    )   echo "Updating mirrorlist.."
                        pacman-mirrors -g ;;
        "Arch Linux" )   if [ -e /etc/pacman.d/mirrorlist.pacnew ]; then
                            echo "Updating mirrorlist.."
                            cp /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist.backup
                            sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
                            rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
                            rm /etc/pacman.d/mirrorlist.pacnew
                        else
                            echo "Mirrors already up-to-date"
                        fi ;;
        *           ) echo "Unsupported OS"
    esac
}

backup () {
	local target
	target="$1"

	tar -cjf "$target"/pacman_db_"$(date --rfc-3339=date)".tar.bz2 /var/lib/pacman/local
}

main () {
    if [ -z "$1" ]; then
        packages && report
    fi
    while echo "$1" | grep -q '-'; do
        case $1 in
            -r )    report ;;
            -p )    packages ;;
            -m )    update_mirrorlist ;;
            -b )	backup "$@";;
            -a )    update_mirrorlist && packages && report && backup "$@";;
            -h )    usage ;;
            *  )    usage
                    exit 1 ;;
        esac
        shift
    done
}

main "$@"
