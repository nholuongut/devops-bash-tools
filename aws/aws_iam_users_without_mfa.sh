#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists AWS IAM users with passwords enabled but without MFA enabled

Outputs a list of users, one per line.


Uses the adjacent script aws_iam_users_mfa_active_report.sh


See similar tools in the DevOps Python Tools repo and The Advanced Nagios Plugins Collection:

    - https://github.com/nholuongutnho/DevOps-Python-tools
    - https://github.com/nholuongutnho/Nagios-Plugins


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

"$srcdir/aws_iam_users_mfa_active_report.sh" |
awk -F, '$2 !~ "false" {print}' |
sed '/,true$/d' |
tail -n +2 |
awk -F, '{print $1}'
