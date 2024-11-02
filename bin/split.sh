#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  # false positives
#  shellcheck disable=SC2178,SC2128

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

usage(){
    if [ -n "$*" ]; then
        echo "$@"
        echo
    fi
    cat <<EOF

Splits big file(s) in to \$PARTS parts (defaults to the number of CPU cores)

Useful for easy parallelizing things that don't easily lend themselves to parallelization like
anonymize.py from DevOps Python Tools which needs successive ordered anonymization rules

usage: ${0##*/} <files>

-p --parts  Number of parts to split files in to (\$PARTS, defaults to number of CPU cores)
-h --help   Show usage and exit

EOF
    exit 3
}

if [ $# -eq 0 ]; then
    usage "no file arguments given"
fi

for x in "$@"; do
    case "$x" in
        -h|--help)  usage
                    ;;
    esac
done

check_bin split
#check_bin parallel

parts="${PARTS:-}"

if [ -z "$parts" ]; then
    parts="$(cpu_count)"
fi

file_list=""

while [ $# -gt 0 ]; do
    case $1 in
           -p|--parts)  parts="$2"
                        shift
                        ;;
         -h|--help|-*)  usage
                        ;;
                    *)  file_list="$file_list $1"
                        ;;
    esac
    shift
done

for filename in $file_list; do
    echo "Splitting $filename in to $parts parts"
    if [ "$(uname -s)" = "Darwin" ]; then
        linecount="$(wc -l < "$filename" | awk '{print $1}')"
        parts="$(bc <<< "$linecount / $parts")"
        split -l "$parts" "$filename" "$filename."
    else
        split -d -n "l/$parts" "$filename" "$filename."
    fi
done
