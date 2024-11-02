#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Renames all IAM user accounts from one domain to another

Useful after company mergers / migrations where you go from firstname.lastname@company1.com to firstname.lastname@company2.com
(even if using mostly AWS SSO you may still need this for your root management account's IAM users)

Group memberships and permissions are retained

Expects that the user@ prefix portion (eg. first.last@) stays the same before and after company migration

Requires AWS CLI and jq to be installed and configured
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<old_domain> <new_domain>"

help_usage "$@"

num_args 2 "$@"

old_domain="$1"
new_domain="$2"

aws iam list-users |
jq -r '.Users[].UserName' |
{ grep "@$old_domain$" || : ; } |
while read -r username; do
    new_username="${username/$old_domain/$new_domain}"
    timestamp "Renaming $username -> $new_username"
    aws iam update-user --user-name "$username" --new-user-name "$new_username"
    echo
done
