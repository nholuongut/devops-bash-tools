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
Prints users access key status and age using a credential report (faster for many users)

CSV Output format:

user,access_key_1_active,access_key_1_last_rotated,access_key_2_active,access_key_2_last_rotated


See Also:

    aws_iam_users_access_key_age.sh


    aws_users_access_key_age.py - in DevOps Python Tools which is able to filter by age and status

    https://github.com/nholuongutnho/DevOps-Python-tools


    awless list accesskeys --format tsv | grep 'years[[:space:]]*$'


AWS Config rule compliance:

    https://<region>.console.aws.amazon.com/config/home?region=<region>&v2=true#/rules/details?configRuleName=access-keys-rotated

eg.

    https://eu-west-1.console.aws.amazon.com/config/home?region=eu-west-1&v2=true#/rules/details?configRuleName=access-keys-rotated


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"


"$srcdir/aws_iam_generate_credentials_report_wait.sh" >&2

# use --decode not -d / -D which varies between Linux and Mac
#if [ "$(uname -s)" = Darwin ]; then
#    base64_decode="base64 -D"
#else
#    base64_decode="base64 -d"
#fi

export AWS_DEFAULT_OUTPUT=json

aws iam get-credential-report --query 'Content' --output text |
base64 --decode |
cut -d, -f1,9,10,14,15
