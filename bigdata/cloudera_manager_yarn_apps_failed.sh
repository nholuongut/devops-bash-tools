#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

# Script to fetch failed Yarn Apps / jobs via Cloudera Manager API
#
# Dumps the raw JSON for further processing, see cloudera_manager_yarn_apps.sh for the format

# Tested on Cloudera Enterprise 5.10

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$srcdir/cloudera_manager_yarn_apps.sh" |
jq -r '.applications[] | select(.state | test("RUNNING|SUCCEEDED|FINISHED|ACCEPTED") | not)'
