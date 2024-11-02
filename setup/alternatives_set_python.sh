#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo=""
[ $EUID -eq 0 ] || sudo=sudo

#$sudo ln -sv -- `type -P python2` /usr/local/bin/python

alternatives(){
    # not available on Alpine
    if type -P alternatives &>/dev/null; then
        $sudo alternatives --set python "$@"
    else
        $sudo ln -sv -- "$1" /usr/local/bin/python
    fi
}

if ! type -P python &>/dev/null; then
    set +e
    python2="$(type -P python2 2>/dev/null)"
    python3="$(type -P python3 2>/dev/null)"
    set -e
    if [ -n "$python3" ]; then
        echo "alternatives: setting python -> $python3"
        # using function wrapper instead for Alpine
        #$sudo alternatives --set python "$python3"
        alternatives "$python3"
    elif [ -n "$python2" ]; then
        echo "alternatives: setting python -> $python2"
        # using function wrapper instead for Alpine
        #$sudo alternatives --set python "$python2"
        alternatives "$python2"
    fi
fi

if ! type -P pip; then
    set +e
    pip2="$(type -P pip2 2>/dev/null)"
    pip3="$(type -P pip3 2>/dev/null)"
    set -e
    if [ -f /usr/local/bin/pip ]; then
        echo "/usr/local/bin/pip already exists, not symlinking - check your \$PATH includes /usr/local/bin (\$PATH = $PATH)"
    elif [ -n "$pip3" ]; then
        $sudo ln -sv -- "$pip3" /usr/local/bin/pip
    elif [ -n "$pip2" ]; then
        $sudo ln -sv -- "$pip2" /usr/local/bin/pip
    else
        $sudo easy_install pip || :
    fi
fi

echo
python -V
echo
"$srcdir/pip_fix_version.sh"
pip -V
echo
