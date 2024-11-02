#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


# Quick script to make it a little easier to query the Google Cloud GCE Metadata API
#
# Must be run from inside GCE otherwise will fail with an error like this:
#
# curl: (6) Could not resolve host: metadata.google.internal

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

usage(){
    echo "
Simple query wrapper to GCE's Metadata API

Lists resources if no argument given

${0##*/} <resource>

eg. ${0##*/} instance/scheduling/preemptible
"
    exit 3
}

if [ $# -gt 1 ] ||
   [[ "${1:-}" =~ -.* ]]; then
    usage
fi

curl -sS -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/${1:-}"

# above doesn't output a trailing newline, when using in shell we usually want this
echo
