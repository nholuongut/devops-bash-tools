#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


# awless list users

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists AWS users


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"


#aws iam list-users | jq -r '.Users[].UserName'
aws iam list-users --query 'Users[*].UserName' --output text | tr '[:space:]' '\n'