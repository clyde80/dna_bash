#!/bin/bash
#
# Prints out a double helix shape in terminal.
#
# Author: clyde80
# Created on: August 30, 2017
# Updated on: August 31, 2017

readonly USAGE="
Usage: $(basename $0) -a [amount of strands] -d [delay]

    OPTIONS

    -a      --amount        Amount of strands to show
    -c      --color         Color to use (0-7)
    -r      --random        Use random colors for everything
    -d      --delay         Update delay
    -h      --help          Display this help message

Author: clyde80
Website: https://github.com/clyde80/dna_bash
Created on: August 30, 2017
Updated on: August 31, 2017

To file a bug report or request a feature, create an issue on Github:
https://github.com/clyde80/dna_bash/issues

Want to contribute to the project? Feel free to fork my project.
https://github.com/clyde80/dna_bash"

readonly BLOCK="█"

# Initial values
spaces_before_level=0
spaces_before_inline_level=3
amount_of_rungs=5
longer=false
shorter=true
delay=0.05
amount_of_strands=5
color=7
rainbow=false

while [[ $# -gt 0 ]]; do
    case $1 in
        "-a"|"--amount") shift; amount_of_strands=$1; shift ;;
        "-c"|"--color")
            shift
            if [[ $1 -ge 0 && $1 -le 7 ]]; then
                color=$1
            else
                echo "Invalid color ($1). Must be 0-7."
            fi
            shift
            ;;
        "-r"|"--rainbow") shift; rainbow=true ;;
        "-d"|"--delay") shift; delay=$1; shift ;;
        "-h"|"--help") echo "$USAGE"; exit ;;
        *) echo "Unknown option: $1"; exit ;;
    esac
done

while true; do
    # Put spaces before the level
    for ((i=0;i<=$spaces_before_level;i++)); do
        echo -n " "
    done

    sleep $delay 


    for ((c=0;c<${amount_of_strands};c++)); do
        if $rainbow; then
            color=$((RANDOM % 8))
        fi
        # Print the level
        echo -en "\e[3${color}m${BLOCK}\e[m"
        for ((i=0;i<${amount_of_rungs};i++)); do
            echo -en "\e[3${color}m-\e[m"
        done

        if [[ ${spaces_before_level} != 3 ]]; then
            echo -en "\e[3${color}m${BLOCK}\e[m"
        fi
        for ((i=0;i<$spaces_before_inline_level;i++)); do
            echo -n " "
        done
    done

    echo ""

    # Update the initial values
    if [[ ${spaces_before_level} == 0 ]]; then
        longer=false
        shorter=true
    elif [[ ${spaces_before_level} == 3 ]]; then
        longer=true
        shorter=false
    fi

    if $longer; then
        spaces_before_level=$((spaces_before_level-1))
        if [[ ${amount_of_rungs} == 0 ]]; then
            amount_of_rungs=1
        else
            amount_of_rungs=$((amount_of_rungs+2))
        fi
        spaces_before_inline_level=$((spaces_before_inline_level-2))
    elif $shorter; then
        spaces_before_level=$((spaces_before_level+1))
        if [[ ${amount_of_rungs} == 1 ]]; then
            amount_of_rungs=0
        else
            amount_of_rungs=$((amount_of_rungs-2))
        fi
        spaces_before_inline_level=$((spaces_before_inline_level+2))
    fi
done
