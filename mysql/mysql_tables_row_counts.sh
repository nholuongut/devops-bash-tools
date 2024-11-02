#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -eu  # -o pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Counts rows for all MySQL tables in all databases using adjacent mysql.sh script

TSV Output format:

<database>.<table>     <row_count>

FILTER environment variable will restrict to matching fully qualified tables (<db>.<table>)

Tested on MySQL 8.0.15
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<mysql_options>]"

help_usage "$@"


exec "$srcdir/mysql_foreach_table.sh" "SELECT COUNT(*) FROM {db}.{table}" "$@"
