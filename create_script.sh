#!/bin/sh

#####################################################
# Name: create_script.sh
#
# Prints a template for a script to stdout
#
# Usage: create_script.sh <script-name>
#
# Possible improvements: more options
#
# Version: 0.2.1
# License: GPLv3
# Author: Till Mahlburg
# Date of Creation: 2017-07-27
#####################################################

construct_script () {
    local date
    date=$(date -I)

    local name
    name="$1"

    local shebang
    shebang="/bin/sh"

    local author
    author=$USER

    echo "#! $shebang"
    echo ''
    echo '#####################################################'
    echo "# Name: $name"
    echo '#'
    echo '# <Description>'
    echo '#'
    echo '# Usage:'
    echo '#'
    echo '# Origin:'
    echo '# License:'
    echo '#'
    echo '# Version: 0.1'
    echo "# Author: $author"
    echo "# Date of Creation: $date"
    echo '######################################################'
    echo ''
    echo '# Functions'
    echo ''
    echo 'usage () {'
    echo 'cat <<- EOF'
    echo 'usage: $(basename "$0") -h'
    echo ''
    echo '<command description>'
    echo ''
    echo 'OPTIONS:'
    echo '    -h shows this help'
    echo 'EOF'
    echo '}'
    echo ''
    echo '# Main functionality. Evaluates the given arguments.'
    echo ''
    echo 'main () {'
    echo '    while getopts "h" opt; do'
    echo '        case $opt in'
    echo '            h )     usage ;;'
    echo '            \? )    usage'
    echo '                    exit 1 ;;'
    echo '            esac'
    echo '    done'
    echo '    shift $((OPTIND - 1))'
    echo ''
    echo '}'
    echo 'main "$@"'
}

main () {
    construct_script "$1"
}

main "$@"
