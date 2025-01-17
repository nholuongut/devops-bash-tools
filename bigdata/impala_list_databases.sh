#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists all Impala databases using adjacent impala_shell.sh script


FILTER environment variable will restrict to matching databases (if giving <db>.<table>, matches up to the first dot)


Tested on Impala 2.7.0, 2.12.0 on CDH 5.10, 5.16 with Kerberos and SSL


For more documentation see the comments at the top of impala_shell.sh

For a better version written in Python see DevOps Python tools repo:

https://github.com/nholuongut/python-for-devops
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<impala_shell_options>]"

help_usage "$@"


# strip comments after database name, eg.
# default Default Hive database
"$srcdir/impala_shell.sh" --quiet -Bq 'SHOW DATABASES' "$@" |
awk '{print $1}' |
while read -r db; do
    if [ -n "${FILTER:-}" ] &&
       ! [[ "$db" =~ ${FILTER%%.*} ]]; then
        continue
    fi
    printf '%s\n' "$db"
done
