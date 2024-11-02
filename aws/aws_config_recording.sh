#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists AWS Config recorders, their recording status (should be true) and their last status (should be success)

eg.

awsconfig  true  SUCCESS


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"


aws configservice describe-configuration-recorder-status --output json |
jq -r '.ConfigurationRecordersStatus[] | [.name, .recording, .lastStatus] | @tsv' |
column -t
