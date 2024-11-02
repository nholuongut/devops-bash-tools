#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists Cloud Trails and their status - if they're logging, multi-region and log file validation enabled

Output Format:

Name      Logging (boolean)   Multi-Region (boolean)    Logfile Validation (boolean)


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

export AWS_DEFAULT_OUTPUT=json

#echo "Getting Cloud Trails" >&2
aws cloudtrail describe-trails |
jq -r '.trailList[] | [.Name, .IsMultiRegionTrail, .LogFileValidationEnabled] | @tsv' |
while read -r name is_multi_region is_validation_enabled; do
    is_logging="$(
        aws cloudtrail get-trail-status --name "$name" |
        jq -r '.IsLogging'
    )"
    echo "$name $is_logging $is_multi_region $is_validation_enabled"
done |
sort |
column -t
