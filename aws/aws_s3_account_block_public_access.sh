#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Blocks S3 public access at the AWS Account level

First arg must be the AWS Account ID. If not given and \$AWS_ACCOUNT_ID is set, will use that, otherwise will infer from the current access key


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<aws_account_id>"

help_usage "$@"

max_args 1

aws_account_id="${1:-}"
shift || :

if [ -z "$aws_account_id" ]; then
    if [ -n "${AWS_ACCOUNT_ID:-}" ]; then
        aws_account_id="$AWS_ACCOUNT_ID"
    else
        timestamp "inferring AWS account id from access key"
        aws_account_id="$(aws_account_id)"
        timestamp "inferred AWS account id to be '$aws_account_id'"
    fi
fi

export AWS_DEFAULT_OUTPUT=json

timestamp "Blocking S3 Public Access for AWS account id '$aws_account_id'"
aws s3control put-public-access-block --account-id "$aws_account_id" --public-access-block-configuration 'BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true'
timestamp "Blocked public access"
