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
Lists all BigQuery tables in all datasets in the current project using the BigQuery Information Schema for each dataset

Output Format:

<project>   <dataset>   <table>

FILTER environment variable will restrict to matching tables (matches against fully qualified table name <dataset>.<schema>.<table>)

Limited to 10,000 table names by default (increase max_rows in script if you have a bigger dataset than this)

Tested on Google BigQuery
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

"$srcdir/bigquery_list_datasets.sh" |
while read -r dataset; do
    "$srcdir/bigquery_list_tables.sh" "$dataset"
done
