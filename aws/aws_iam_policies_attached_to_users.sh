#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Finds and prints all policies directly attached to users instead of groups

Policies directly attached to users is against best practice as it is harder to maintain


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"


# prefix user column only if there is any output
prefix_user(){
    sed "s/^\\(.\\)/${user}   &/"
    #while read line; do
    #    if [ -n "$line" ]; then
    #        echo "$user $line"
    #    fi
    #done
}

export AWS_DEFAULT_OUTPUT=json

echo "output will be formatted in to columns at end" >&2
echo "getting user list" >&2
aws iam list-users |
jq -r '.Users[].UserName' |
while read -r user; do
    echo "querying user $user" >&2
    aws iam list-attached-user-policies --user-name "$user" | jq -r '.AttachedPolicies[] | [.PolicyName, .PolicyArn] | @tsv' | prefix_user
    aws iam list-user-policies --user-name "$user" | jq -r '.PolicyNames[] | [.PolicyName, .PolicyArn] | @tsv' | prefix_user
done |
column -t
