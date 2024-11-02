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
Show table location for all tables via Impala shell

Output Format:

<db>.<table>    <location>


FILTER environment variable will restrict to matching fully qualified tables (<db>.<table>)


Caveats:

    Hive is more reliable as Impala breaks on some table metadata definitions where Hive doesn't

    Impala is faster than Hive for the first ~1000 tables but then slows down
    so if you have a lot of tables I recommend you use the Hive version of this instead


Tested on Impala 2.7.0, 2.12.0 on CDH 5.10, 5.16 with Kerberos and SSL


For more documentation see the comments at the top of impala_shell.sh

For a better version written in Python see DevOps Python tools repo:

    https://github.com/nholuongut/python-for-devops
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<impala_shell_options>]"

help_usage "$@"


exec "$srcdir/impala_tables_metadata.sh" Location "$@"
