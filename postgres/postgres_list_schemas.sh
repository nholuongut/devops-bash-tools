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
Lists all PostgreSQL schemas using adjacent psql.sh script

FILTER environment variable will restrict to matching schemas (matches against fully qualified schema name <db>.<schema>)

AUTOFILTER if set to any value skips information_schema and pg_catalog schemas

Tested on AWS RDS PostgreSQL 9.5.15
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<psql_options>]"

help_usage "$@"


"$srcdir/psql.sh" -q -t -c "SELECT DISTINCT table_catalog, table_schema FROM information_schema.tables ORDER BY table_catalog, table_schema;" "$@" |
sed 's/|//g; s/^[[:space:]]*//; s/[[:space:]]*$//; /^[[:space:]]*$/d' |
if [ -n "${AUTOFILTER:-}" ]; then
    grep -Ev '[[:space:]](information_schema|pg_catalog)$'
else
    cat
fi |
while read -r db schema; do
    if [ -n "${FILTER:-}" ] &&
       ! [[ "$db.$schema" =~ $FILTER ]]; then
        continue
    fi
    printf '%s\t%s\n' "$db" "$schema"
done
