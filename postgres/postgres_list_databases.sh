#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists all PostgreSQL databases using adjacent psql.sh script

FILTER environment variable will restrict to matching databases (if giving <db>.<table>, matches up to the first dot)

Tested on AWS RDS PostgreSQL 9.5.15
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<psql_options>]"

help_usage "$@"


"$srcdir/psql.sh" -q -t -c 'SELECT DISTINCT(table_catalog) FROM information_schema.tables ORDER BY table_catalog;' "$@" |
sed 's/^[[:space:]]*//; s/[[:space:]]*$//; /^[[:space:]]*$/d' |
while read -r db; do
    if [ -n "${FILTER:-}" ] &&
       ! [[ "$db" =~ ${FILTER%%.*} ]]; then
        continue
    fi
    printf '%s\n' "$db"
done
