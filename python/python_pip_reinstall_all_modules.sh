#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


# Reinstalls all Python Pip modules which is often the fix for the python startup error
#
# "Illegal instruction: 4"
#
# which is often caused by some corrupted module or incompatability vs local CPU architecture
# which recompiling often solves

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -n "${PIP:-}" ]; then
    pip="$PIP"
else
    pip=pip
    if ! type -P "pip" &>/dev/null; then
        echo "pip not found, falling back to pip2"
        pip=pip2
    fi
fi
opts="${PIP_OPTS:-}"

# want splitting
# shellcheck disable=SC2086
"$pip" $opts freeze | PIP_OPTS="--force-reinstall" xargs "$srcdir/python_pip_install.sh"
