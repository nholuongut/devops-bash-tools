#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists Cloud Trails buckets and their Access Logging prefix and target bucket

Output Format:

CloudTrail_S3_Bucket      TargetPrefix    TargetBucket

If access logging isn't configured on the bucket, outputs:

CloudTrail_S3_Bucket      S3_ACCESS_LOGGING_NOT_CONFIGURED


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

export AWS_DEFAULT_OUTPUT=json

aws cloudtrail describe-trails --query 'trailList[*].S3BucketName' |
jq -r '.[]' |
while read -r name; do
    printf '%s\t' "$name"
    output="$(aws s3api get-bucket-logging --bucket "$name" |
    jq -r '.LoggingEnabled | [.TargetPrefix, .TargetBucket] | @tsv')"
    if [ -z "$output" ]; then
        echo "S3_ACCESS_LOGGING_NOT_CONFIGURED"
    else
        echo "$output"
    fi
done |
sort |
column -t
