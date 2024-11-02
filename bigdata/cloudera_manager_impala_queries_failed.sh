#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

# Script to show recent Impala query metadata errors via Cloudera Manager API
#
# TSV output format:
#
# <time>    <database>      <user>      <query error>

# Tested on Cloudera Enterprise 5.10

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$srcdir/cloudera_manager_impala_queries.sh" |
jq -r '.queries[] |
       select(.attributes.query_status | test("failed"; "i")) |
       [.startTime, .database, .user, .statement, .attributes.query_status] |
       @tsv'
