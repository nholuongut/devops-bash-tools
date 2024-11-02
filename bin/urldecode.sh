#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
# Quick command line URL decoding

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

if [ $# -gt 0 ]; then
    echo "$@"
else
    cat
fi |
perl -MURI::Escape -ne 'chomp; print uri_unescape($_) . "\n"'
