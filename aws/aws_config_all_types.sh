#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists AWS Config recorders, checking all resource types are supported (should be true) and includes global resources (should be true)

eg.

awsconfig  true  true


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"


aws configservice describe-configuration-recorders --output json |
jq -r '.ConfigurationRecorders[] | [.name, .recordingGroup.allSupported, .recordingGroup.includeGlobalResourceTypes] | @tsv' |
column -t