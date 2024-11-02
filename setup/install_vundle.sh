#!/usr/bin/env bash
# shellcheck disable=SC2230

# Installs Vim plugin manager Vundle to $HOME/.vim/bundle/Vundle.vim

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

if ! type -P vim &>/dev/null; then
    echo "Vim not installed, aborting..."
    exit 1
fi

target=~/.vim/bundle/Vundle.vim

mkdir -pv "${target%/*}"

if ! [ -e "$target" ]; then
    git clone https://github.com/gmarik/Vundle.vim.git "$target"
fi

date "+%F %T  Installing Vim Vundle plugins..."
# this tends to mess up the terminal and requires a reset afterwards
vim --not-a-term +PluginInstall +qall >/dev/null
date "+%F %T  Finished installing Vim Vundle plugins"
