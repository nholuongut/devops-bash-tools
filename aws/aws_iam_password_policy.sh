#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Prints password policy in 'key = value' pairs for easy viewing / grepping

See Also:

    aws_iam_harden_password_policy.sh - sets a hardeded password policy along CIS Foundations Benchmark recommendations
                                        that script calls this one before and after changing the password policy


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"


aws iam get-account-password-policy --output json |
jq -r '.PasswordPolicy | to_entries | map(.key + " = " + (.value | tostring)) | .[]'
