#!/bin/sh
#  vim:ts=4:sts=4:sw=4:et

set -u
[ -n "${DEBUG:-}" ] && set -x

echo "Python / Pip versions installed:"
echo

# executing in sh where type is not available
#type -P python
for x in python python2 python3 pip pip2 pip3; do
    cmdpath="$(command -v "$x" 2>/dev/null)"
    if [ -n "$cmdpath" ]; then
        printf "%s" "$cmdpath => "
        "$cmdpath" -V
    fi
done
echo
for x in python python2 python3 pip pip2 pip3; do
    cmdpath="$(command -v "$x" 2>/dev/null)"
    if [ -n "$cmdpath" ]; then
        ls -l "$cmdpath"
    fi
done
