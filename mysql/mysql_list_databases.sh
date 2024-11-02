#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists all MySQL databases using adjacent mysql.sh script

FILTER environment variable will restrict to matching databases (if giving <db>.<table>, matches up to the first dot)

AUTOFILTER if set to any value skips information_schema, performance_schema, sys and mysql databases

Tested on MySQL 8.0.15
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<mysql_options>]"

help_usage "$@"

"$srcdir/mysql.sh" -s -e 'SELECT DISTINCT(table_schema) FROM information_schema.tables ORDER BY table_schema;' "$@" |
sed 's/^[[:space:]]*//; s/[[:space:]]*$//; /^[[:space:]]*$/d' |
if [ -n "${AUTOFILTER:-}" ]; then
    grep -Ev '^(information_schema|performance_schema|sys|mysql)$'
else
    cat
fi |
while read -r db; do
    if [ -n "${FILTER:-}" ] &&
       ! [[ "$db" =~ ${FILTER%%.*} ]]; then
        continue
    fi
    printf '%s\n' "$db"
done
