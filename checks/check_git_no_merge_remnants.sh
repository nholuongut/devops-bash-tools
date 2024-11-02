#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

section "Checking no Git / Diff merge remnants"

if [ -n "${1:-}" ]; then
    if ! [ -d "$1" ]; then
        echo "No such file or directory $1"
        exit 1
    fi
    pushd "$1"
fi

start_time="$(start_timer)"

regex='^([<]<<<<<<|>>>>>>[>])'

echo "searching for '$regex' under $PWD:"
echo
# slow, may scan filesystem containing large files - can waste minutes of time
#if grep -IER "$regex" --devices=skip --exclude-dir={.git} . 2>/dev/null; then
if git grep -IE "$regex" . 2>/dev/null; then
    echo
    echo "FOUND Git / Diff merge remnants!"
    exit 1
fi

time_taken "$start_time"
section2 "No git / diff merge remnants found"
echo
