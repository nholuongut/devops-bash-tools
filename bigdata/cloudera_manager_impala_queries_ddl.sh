#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
# Script to show recent Impala metadata refresh calls via Cloudera Manager API
#
# TSV output format:
#
# <time>    <database>  <user>      <statement>

# Tested on Cloudera Enterprise 5.10

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$srcdir/cloudera_manager_impala_queries.sh" |
jq -r '.queries[] |
       select(.queryType == "DDL") |
       select(.statement | test("^\\s*(USE|DESCRIBE|GET_TABLES|GET_SCHEMAS|REFRESH)"; "i") | not) |
       [.startTime, .database, .user, .statement] |
       @tsv'
