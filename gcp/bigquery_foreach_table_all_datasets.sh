#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: echo "project = {project}, dataset = {dataset} / schema = {schema}, table = {table}"


set -eu  # -o pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Execute a command against all Google BigQuery tables in all datasets in the current project

Command can contain {project}, {dataset} / {schema} and {table} placeholders which will be replaced for each table

WARNING: do not run any command reading from standard input, otherwise it will consume the dataset names and exit after the first iteration

Requires GCloud SDK which must be configured and authorized for the project

Tested on Google BigQuery
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<command>"

help_usage "$@"

min_args 1 "$@"

command_template="$*"

# exit the loop subshell if you Control-C
trap 'exit 130' INT

"$srcdir/bigquery_list_datasets.sh" |
while read -r dataset; do
    "$srcdir/bigquery_foreach_table.sh" "$dataset" "$command_template"
done
