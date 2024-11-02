#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Prints users access keys and their last used date using a credentials report (faster for many users)

CSV Output format:

user,access_key_1_active,access_key_1_last_used_date,access_key_2_active,access_key_2_last_used_date


See similar tools in DevOps Python Tools repo:

    https://github.com/nholuongutnho/DevOps-Python-tools


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

aws iam get-credential-report --query 'Content' --output text |
base64 --decode |
cut -d, -f1,9,11,14,16
