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
Counts rows for all PostgreSQL tables in all databases using adjacent psql.sh script

TSV Output format:

<database>.<schema>.<table>     <row_count>

FILTER environment variable will restrict to matching fully qualified tables (<db>.<schema>.<table>)

Tested on AWS RDS PostgreSQL 9.5.15
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<psql_options>]"

help_usage "$@"


"$srcdir/postgres_foreach_table.sh" "SELECT COUNT(*) FROM {db}.{schema}.{table}" "$@" |
sed '/^[[:space:]]*$/d'
