#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
# you will almost certainly have to comment out / remove '-o pipefail' to skip authorization errors such as that documented in impala_list_tables.sh
set -eu  # -o pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Show table location for all tables via beeline

Output Format:

<db>.<table>    <location>


FILTER environment variable will restrict to matching fully qualified tables (<db>.<table>)


Tested on Hive 1.1.0 on CDH 5.10, 5.16


For more documentation see the comments at the top of beeline.sh

For a better version written in Python see DevOps Python tools repo:

    https://github.com/nholuongut/python-for-devops
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<beeline_options>]"

help_usage "$@"


exec "$srcdir/hive_tables_metadata.sh" Location "$@"
