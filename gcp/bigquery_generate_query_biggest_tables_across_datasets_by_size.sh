#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Generates an SQL query to find the Top 10 biggest tables by row count across all BigQuery datasets in the current GCP project

Prints the SQL query to standard output. Pipe this to the 'bq query' command to execute

Requires GCloud SDK to be installed and authorized
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

union_all="$(NO_HEADING=1 "$srcdir/bigquery_foreach_dataset.sh" "echo 'SELECT * FROM {dataset_id}.__TABLES__ UNION ALL'")"

union_all="${union_all%UNION ALL}"

query="
WITH ALL__TABLES__ AS (
$union_all
)
SELECT
  project_id,
  dataset_id,
  table_id,
  ROUND(size_bytes/pow(10,9),2) as size_gb,
  row_count,
  TIMESTAMP_MILLIS(creation_time) AS creation_time,
  TIMESTAMP_MILLIS(last_modified_time) as last_modified_time,
  CASE
    WHEN type = 1 THEN 'table'
    WHEN type = 2 THEN 'view'
  ELSE NULL
  END AS type
FROM
  ALL__TABLES__
ORDER BY
  size_gb DESC,
  row_count DESC
LIMIT 10;
"

echo "$query"
