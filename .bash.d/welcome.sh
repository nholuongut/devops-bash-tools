#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
# ============================================================================ #
#                                 W e l c o m e
# ============================================================================ #

# Original version was in Perl many years ago, but defaulting to Python version now

# Bash version further down is for interest of if you don't have the other repos

# welcome should be found in $PATH from DevOps-Golang-Tools repo
# welcome.py should be found in $PATH from DevOps-Python-Tools repo
welcome(){
    if type -P welcome &>/dev/null; then
        command welcome
    elif type -P welcome.py &>/dev/null; then
        welcome.py
    fi
}

# set this instead to use bash only version if you don't have the other repos
#alias welcome=bash_welcome

bash_welcome(){
    local msg
    msg="Welcome nholuongut - your last access was $(last|head -n2|tail -n1|sed 's/[^ ]\+ \+[^ ]\+ \+[^ ]\+ \+//;s/ *$//')"
    #local msg="Welcome nholuongut"
    # generated by for x in {A..z}; do printf "%s" $x; done
    #charmap="ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_\`abcdefghijklmnopqrstuvwxyz"
    # generated by: for x in {1..128}; do printf \\$(printf '%03o' $x); done
    # shellcheck disable=SC1117
    charmap="!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_\`abcdefghijklmnopqrstuvwxyz{|}~ \t\n"
    for ((i=0; i<"${#msg}"; i++)); do
        local x="${msg:i:1}"
        #echo "x == $x"
        printf " "
        local j=0
        while true; do
        #for ((j=0; j<"${#charmap}"; j++)); do
        #while true; do
            #set -x
            if [ $j -gt 2 ]; then
                local y=$x
            else
                local y=${charmap:$((RANDOM%${#charmap})):1}
            fi
            #local y="${charmap:j:1}"
            printf "\\b%s" "$y"
            # This does not have enough precision, re-implement in Perl
            # This is because it's an external being called, otherwise pure bash
            # is so fast that you don't see any effect...
            sleep 0.000000000001
            #perl -e 'sleep 0.0000000000000000000000000001'
            [ "$y" = "$x" ] && break
            ((j+=1))
            #set +x
        done
    done
    #printf "\\n"
    printf "\\n"
}
