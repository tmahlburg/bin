## bin
This repository contains all the little helper programs I got from somewhere else or wrote myself. If the script is from someone else, there is a source information in the top comment. The scripts I wrote myself are POSIX-compatible, except for the usage of the 'local' which is supported on almost every modern bourne-like shell (bash, ash, dash, ksh). Most of them are licensed with the GPLv3 (see LICENSE), but some are under CC0. The license used is written in each source file.

To help you, I made a list with short descriptions of the scripts, that are useful for others.
### The most universally useful
- **alpine-sysinfo** - a nice looking sysinfo script, specifically for alpine linux.
- **benchscript** - allows you to launch an application multiple times trough a terminal of your choosing, and times that process. Note that the launched application needs to close itself.
- **create_script.sh** - prints the skeleton of a shellscript to stdout.
- **indie_pkg** - prints a list of all manually installed packages, which no other packages depend on. it works on voidlinux systems.
- **maintenance.sh** - combines different tasks of system maintenance on an arch, manjaro or voidlinux systems. It can automate package- and mirror-related tasks as well as generating a report on the general system health/status.
- **xtc** - converts a common .Xresources colorscheme to my preferred format.

The rest are mostly collected and edited from various or pretty specific. Look at the source, if you are interested anyway.
