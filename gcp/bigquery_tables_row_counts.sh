#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: bigquery-public-data.github_repos


set -eu  # -o pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Counts rows for all BigQuery tables in the given dataset

Output:

<project>.<dataset>.<table>     <row_count>


Requires GCloud SDK which must be configured and authorized for the project

Tested on Google BigQuery
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<project>.]<dataset>"

help_usage "$@"

min_args 1 "$@"

# validated in bigquery_list_tables.sh
dataset="$1"

# exit the loop subshell if you Control-C
trap 'exit 130' INT

export NO_HEADING=1

"$srcdir/bigquery_foreach_table.sh" "$dataset" "$srcdir/bigquery_table_row_count.sh" "{project}.{dataset}.{table}"
