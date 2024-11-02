#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists Cloud Trails and whether their S3 buckets are KMS secured

Output Format:

CloudTrail_Name      S3_KMS_secured (boolean)     KMS_Key_Id


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

export AWS_DEFAULT_OUTPUT=json

aws cloudtrail describe-trails |
# more efficient
jq -r '.trailList[] | [.Name, has("KmsKeyId"), .KmsKeyId // "N/A"] | @tsv' |
#jq -r '.trailList[] | [.Name, .KmsKeyId] | @tsv' |
#while read -r name keyid; do
#    kms_secured=false
#    if [ -n "$keyid" ]; then
#        kms_secured=true
#    else
#        keyid="N/A"
#    fi
#    printf "%s\t%s\t%s" "$name" "$kms_secured" "$keyid"
#done |
sort |
column -t
