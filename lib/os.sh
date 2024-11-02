#!/bin/sh
#  vim:ts=4:sts=4:sw=4:et
#

set -eu
[ -n "${DEBUG:-}" ] && set -x

is_linux(){
    if [ "$(uname -s)" = "Linux" ]; then
        return 0
    fi
    return 1
}

is_mac(){
    if [ "$(uname -s)" = "Darwin" ]; then
        return 0
    fi
    return 1
}
