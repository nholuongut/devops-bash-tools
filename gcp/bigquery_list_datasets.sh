#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists the BigQuery datasets in the current GCP project, one per line

Requires GCloud SDK which must be configured and authorized for the project

Tested on Google BigQuery
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

#set +e
#output="$(bq ls --quiet --headless --format=json)"
## shellcheck disable=SC2181
#if [ $? != 0 ]; then
#    echo "$output" >&2
#    exit 1
#fi
#set -e
bq ls --quiet --headless --format=json |
jq -r '.[].datasetReference.datasetId'
