#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

# Script to show recent Impala exceptions querievia Cloudera Manager API
#
# Tab-separated output format:
#
# <time>    <database>  <user>  <statement may be long>     <error>

# Tested on Cloudera Enterprise 5.10

# Caveat: this doesn't catch things like:
#
# "query_status" : "\nFailed to open HDFS file hdfs://nameservice1/user/hive/warehouse/<database>.db/<table>/part-r-00030-1a234567-8bc9-01d2-e345-678fa901b2c3.snappy.parquet\nError(2): No such file or directory\n",
#
# because they have
#
# queryState" : "CREATED" instead of queryState" : "EXCEPTION"
#
# You can instead find those sorts of things using cloudera_manager_impala_queries_metadata_errors.sh

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$srcdir/cloudera_manager_impala_queries.sh" |
jq -r '.queries[] |
       select(.queryState == "EXCEPTION") |
       [.startTime, .database, .user, .statement, .attributes.query_status] |
       @tsv'
