#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -eu -o pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Get row counts for all Hive tables in all databases via beeline

TSV Output format:

<database>.<table>     <row_count>


FILTER environment variable will restrict to matching fully qualified tables (<db>.<table>)


Tested on Hive 1.1.0 on CDH 5.10, 5.16


For a better version written in Python see DevOps Python tools repo:

    https://github.com/nholuongut/python-for-devops

you will need to comment out / remove '-o pipefail' below to skip errors if you aren't authorized to use
any of the databases to avoid the script exiting early upon encountering any authorization error such:

ERROR: AuthorizationException: User '<user>@<domain>' does not have privileges to access: default   Default Hive database.*.*
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<beeline_options>]"

help_usage "$@"


exec "$srcdir/hive_foreach_table.sh" "SELECT COUNT(*) FROM {db}.{table}" "$@"
