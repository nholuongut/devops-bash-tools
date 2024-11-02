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
Print each table's DDL metadata field eg. Location

Output Format:

<db>.<table>    <field>


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
usage_args="<metadata_field> [<impala_shell_options>]"

help_usage "$@"

min_args 1 "$@"

field="$1"
shift || :

query_template="describe formatted {table}"

# exit the loop subshell if you Control-C
trap 'exit 130' INT

"$srcdir/impala_list_tables.sh" "$@" |
while read -r db table; do
    printf '%s.%s\t' "$db" "$table"
    query="${query_template//\{db\}/\`$db\`}"
    query="${query//\{table\}/\`$table\`}"
    { "$srcdir/impala_shell.sh" --quiet -Bq "USE \`$db\`; $query" "$@" || echo "ERROR running query: $query" >&2; } |
    {  grep "^$field" || echo UNKNOWN; } |
    sed "s/^$field:[[:space:]]*//; s/[[:space:]]*NULL[[:space:]]*$//"
done
