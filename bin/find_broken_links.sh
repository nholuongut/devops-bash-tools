#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

# Crawls a URL argument and finds broken links, throttling to 1 link every 2 seconds

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

usage(){
    if [ -n "$*" ]; then
        echo "$*"
    fi
    cat <<EOF

usage: ${0##*/} <url>

EOF
    exit 3
}

if [ $# != 1 ]; then
    usage "no url argument given"
fi

url="$1"

if ! [[ "$url" =~ https?:// ]]; then
    usage "invalid url argument, must match https?://"
fi

tmp="$(mktemp)"

# want splitting
# shellcheck disable=SC2086
trap 'rm -- "$tmp"' $TRAP_SIGNALS

# --spider = don't download
# -r = recursive
# -nd / --no-directories = don't create local dirs representing structure
# -nv / --no-verbose = give concise 1 liner information
# -l 1 = crawl 1 level deep (may need to tune this), set to 'inf' for infinite
# -w 2 = wait for 2 secs between requests to avoid tripping defenses
# -H / --span-hosts = follows subdomains + external sites
# -o "$tmp" = output to tmp, now replaced with tee
# -N = --timestamping = don't download unless newer than local copy, use with mirroring not spidering
# -nH = -–no-host-directories
# -P = --directory-prefix (use instead of host directories)
# -m = --mirror (-r -N -l inf –no-remove-listing)
wget \
     --spider \
     -r \
     -nd \
     -nv \
     -l 1 \
     -w 2 --random-wait \
     -H \
     "$url" 2>&1 |
tee "$tmp"
if ! grep -q 'Found no broken links' "$tmp"; then
    echo
    echo "Broken links:"
    grep -B1 'broken link!' "$tmp"
fi
