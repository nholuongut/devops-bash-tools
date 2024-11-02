#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Creates a word freqency list ranked by most used words at the top

Works like a standard unix filter program - pass in stdin or give it a filename, and outputs to stdout, so you can continue to pipe or redirect to a file as usual
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<filename>]"

help_usage "$@"

#min_args 1 "$@"

#filename="$1"

if [ $# -eq 0 ]; then
    echo "Reading from stdin" >&2
fi

#output_file="$filename.word_frequency.txt"

# one of the few legit uses of cat - tr can't process a filename arg or stdin
cat "$@" |
tr ' ' '\n' |
sed '
    /^[[:space:]]*$/d;
    # because sometimes you want to see the occurence of emojis in WhatsApp chats
    #/^[^[:alnum:]]*$/d;
' |
tr '[:upper:]' '[:lower:]' |
sort |
uniq -c |
sort -k1nr  # > "$output_file"

#head -n "$LINES" "$output_file"
