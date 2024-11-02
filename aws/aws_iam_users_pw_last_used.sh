#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists AWS IAM users and their password last used date

See Also:

    - check_aws_users_password_last_used.py in the Advanced Nagios Plugins collection

        https://github.com/nholuongutnho/Nagios-Plugins

    awless list users

    awless list users --format tsv | awk '{if(\$4 == \"months\" || \$4 == \"years\") print}'


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

export AWS_DEFAULT_OUTPUT=json

aws iam list-users |
jq -r '.Users[] | [.UserName, .PasswordLastUsed] | @tsv' |
#while read -r username password_last_used; do
#    printf '%s\t%s\n' "$username" "${password_last_used:-N/A}"
#done |
awk '{if(NF==1){$2="N/A"}print}' |
column -t
