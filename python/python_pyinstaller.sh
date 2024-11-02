#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


# Creates PyInstaller self-contained bundles of all python files given as args or all python files in the current and first subdirectory (to avoid creating bundles of libraries)

set -u
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

filelist="$(find "${1:-.}" -maxdepth 2 -type f -iname '*.py')"

if [ -z "$filelist" ]; then
    echo "no Python"
    echo
    echo "usage: ${0##*/} <python_file_or_directory>"
    echo
    return 0 &>/dev/null || :
    exit 0
fi

section "Compiling and bundling Python code using PyInstaller"

start_time="$(start_timer)"

opts=(${PYINSTALL_OPTS:+"$PYINSTALLER_OPTS"})

opts+=(-y)
if [ -d pylib ]; then
    opts+=(--paths pylib)
    if [ -d pylib/resources ]; then
        for filename in pylib/resources/*; do
            opts+=(--add-data "$filename:resources")
        done
    fi
fi

for filename in $filelist; do
    type isExcluded &>/dev/null && isExcluded "$filename" && continue
    echo "compiling $filename => dist/$filename"
    # want opt expansion
    # shellcheck disable=SC2086
    pyinstaller ${opts:+"${opts[@]}"} "$filename"
    echo
done

time_taken "$start_time"
section2 "Finished PyInstaller compilation"
echo
