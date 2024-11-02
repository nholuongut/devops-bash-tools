#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

# ============================================================================ #
#                                 S p i n n e r
# ============================================================================ #

spinner(){
    local msg="$* "
    #local num=${2:-100}
    local num=1000
    #local delay=${3:-0.00001}
    local delay=0.00001
    spin='-\|/'
    #printf "${msg//?/ }"
    printf "%s" "$msg "
    for ((i=0; i < num; i++)); do
        sleep $delay
        # This way results in more flashing
        #printf "\r${msg}${spin:$((${i}%${#spin})):1}"
        # TODO: naughty allowing variables in printf format string but fiddly with msg var replaced backspace otherwise, clean up later...
        # shellcheck disable=SC2059
        printf "\\b${msg//?/\\b}${msg}${spin:$((i % ${#spin})):1}"
    done
    printf '\b '
    echo
    echo "done"
}
