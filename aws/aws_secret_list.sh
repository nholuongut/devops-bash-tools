#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists AWS Secrets Manager secrets, one per line

Any args are passed directly to 'aws secretsmanager'


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<aws_options>]"

help_usage "$@"

aws secretsmanager list-secrets "$@" |
jq_debug_pipe_dump |
jq -r '.SecretList[].Name'
