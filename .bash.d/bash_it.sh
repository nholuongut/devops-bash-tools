#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

# ============================================================================ #
#                                 B a s h   I T
# ============================================================================ #

return

if ! [ -d ~/.bash_it ]; then
    git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
fi

export BASH_IT=~/.bash_it

export BASH_IT_THEME='bobby'
