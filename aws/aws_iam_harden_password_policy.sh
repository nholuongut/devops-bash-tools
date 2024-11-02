#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Strengthens password policy according to CIS Foundations Benchmark recommendations

View password policy using adjacent script aws_password_policy.sh (automatically called at start and end of this script)


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"


echo
echo "Existing Password Policy:"
echo
"$srcdir/aws_iam_password_policy.sh"
echo
echo
echo "Setting Hardened Password Policy:"
echo
set -x
aws iam update-account-password-policy --require-uppercase-characters
aws iam update-account-password-policy --require-lowercase-characters
aws iam update-account-password-policy --require-symbols
aws iam update-account-password-policy --require-numbers
aws iam update-account-password-policy --minimum-password-length 14
aws iam update-account-password-policy --password-reuse-prevention 24
aws iam update-account-password-policy --max-password-age 90
set +x
echo
echo
echo "New Password Policy:"
echo
"$srcdir/aws_iam_password_policy.sh"
