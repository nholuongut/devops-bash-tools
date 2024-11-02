#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists all Impala tables in all databases using adjacent impala_shell.sh script

Output Format:

<db>    <table>


FILTER environment variable will restrict to matching fully qualified tables (<db>.<table>)


Tested on Impala 2.7.0, 2.12.0 on CDH 5.10, 5.16 with Kerberos and SSL


For more documentation see the comments at the top of impala_shell.sh

For a better version written in Python see DevOps Python tools repo:

    https://github.com/nholuongut/python-for-devops

you will need to comment out / remove 'set -o pipefail' below to skip errors if you aren't authorized to use
any of the databases to avoid the script exiting early upon encountering any authorization error such:

ERROR: AuthorizationException: User '<user>@<domain>' does not have privileges to access: default   Default Hive database.*.*
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<impala_shell_options>]"

help_usage "$@"


"$srcdir/impala_list_databases.sh" |
while read -r db; do
    "$srcdir/impala_shell.sh" --quiet -Bq "SHOW TABLES IN \`$db\`" "$@" |
    sed "s/^/$db	/"
done |
while read -r db table; do
    if [ -n "${FILTER:-}" ] &&
       ! [[ "$db.$table" =~ $FILTER ]]; then
        continue
    fi
    printf '%s\t%s\n' "$db" "$table"
done
