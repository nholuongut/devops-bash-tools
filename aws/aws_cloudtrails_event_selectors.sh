#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists Cloud Trails and their event selectors

To check there is at least one event selector for each trail with IncludeManagementEvents set to true and ReadWriteType set to All

Output Format:

Name      IncludeManagementEvents (boolean)   ReadWriteType (All)     DataResources (optional)


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

export AWS_DEFAULT_OUTPUT=json

#echo "Getting Cloud Trails" >&2
aws cloudtrail describe-trails |
jq -r '.trailList[].Name' |
while read -r name; do
    echo -n "$name "
    aws cloudtrail get-event-selectors --trail-name "$name" |
    jq -r '.EventSelectors[] | [.IncludeManagementEvents, .ReadWriteType, .DataResources[]] | @tsv'
done |
sort |
column -t
