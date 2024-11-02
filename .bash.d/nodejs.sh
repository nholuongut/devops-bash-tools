#!/usr/bin/env bash
# shellcheck disable=SC2230
#  vim:ts=4:sts=4:sw=4:et

# ============================================================================ #
#                                    N o d e
# ============================================================================ #

bash_tools="${bash_tools:-$(dirname "${BASH_SOURCE[0]}")/..}"

# shellcheck disable=SC1090,SC1091
#. "$bash_tools/.bash.d/os_detection.sh"

#type add_PATH &>/dev/null || . "$bash_tools/.bash.d/paths.sh"

# output from 'npm bin'
if [ -d ~/node_modules/.bin ]; then
    add_PATH ~/node_modules/.bin
fi

if [ -d "$bash_tools/node_modules/.bin" ]; then
    add_PATH "$bash_tools/node_modules/.bin"
fi

alias lsnodebin='ls -d ~/node_modules/.bin/* 2>/dev/null'
alias llnodebin='ls -ld ~/node_modules/.bin/* 2>/dev/null'
