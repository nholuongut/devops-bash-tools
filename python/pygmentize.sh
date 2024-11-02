#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


#set -euo pipefail
#[ -n "${DEBUG:-}" ] && set -x

# idea from https://superuser.com/questions/117841/when-reading-a-file-with-less-or-more-how-can-i-get-the-content-in-colors

if [ $# -gt 0 ]; then
    case "$1" in
        *.ad[asb]|\
        *.asm|\
        *.awk|\
        *.axp|\
        *.diff|\
        *.ebuild|\
        *.eclass|\
        *.groff|\
        *.hh|\
        *.inc|\
        *.java|\
        *.js|\
        *.lsp|\
        *.l|\
        *.m4|\
        *.pas|\
        *.patch|\
        *.php|\
        *.pl|\
        *.pm|\
        *.pod|\
        *.pov|\
        *.ppd|\
        *.py|\
        *.p|\
        *.rb|\
        *.sh|\
        *.sql|\
        *.xml|\
        *.xps|\
        *.xsl|\
        *.[ch]pp|\
        *.[ch]xx|\
        *.[ch]\
            )   pygmentize -f 256 "$1"
                ;;

        .bash*) pygmentize -f 256 -l sh "$1"
                ;;

        *)
            if grep -q '#!.*bash' "$1" 2> /dev/null; then
                pygmentize -f 256 -l sh "$1"
            else
                exit 1
            fi
    esac
else
    pygmentize -f 256 -g
fi

exit 0
