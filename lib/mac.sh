#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


# designed to be included from utils.sh

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

if ! is_mac; then
    return
fi

if ! type tac &>/dev/null; then
    tac(){
        gtac "$@"
    }
fi
