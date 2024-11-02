#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Run SQL query against all Hive tables in all databases via beeline

Query can contain {db} and {table} placeholders which will be replaced for each table

FILTER environment variable will restrict to matching fully qualified tables (<db>.<table>)

WARNING: do not run any subshell command reading from standard input, otherwise it will consume the db/table names and exit after the first iteration


Tested on Hive 1.1.0 on CDH 5.10, 5.16


For a better version written in Python see DevOps Python tools repo:

    https://github.com/nholuongut/python-for-devops

you will need to comment out / remove the 'set -o pipefail' to skip errors if you aren't authorized to use
any of the databases to avoid the script exiting early upon encountering any authorization error such:

ERROR: AuthorizationException: User '<user>@<domain>' does not have privileges to access: default   Default Hive database.*.*
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="\"<query>\" [<beeline_options>]"

help_usage "$@"

min_args 1 "$@"

query_template="$1"
shift || :

opts="--silent=true --outputformat=tsv2"

# exit the loop subshell if you Control-C
trap 'exit 130' INT

# shellcheck disable=SC2086
"$srcdir/hive_list_tables.sh" "$@" |
while read -r db table; do
    printf '%s.%s\t' "$db" "$table"
    query="${query_template//\{db\}/\`$db\`}"
    query="${query//\{table\}/\`$table\`}"
    "$srcdir/beeline.sh" $opts -e "USE \`$db\`; $query" "$@" |
    tail -n +2
done
