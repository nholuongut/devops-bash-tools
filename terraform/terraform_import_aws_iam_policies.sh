#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Parses Terraform Plan for aws_iam_policy additions and imports each one into Terraform state

If \$TERRAFORM_PRINT_ONLY is set to any value, prints the commands to stdout to collect so you can check, collect into a text file or pipe to a shell or further manipulate, ignore errors etc.


Requires Terraform to be installed and configured
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<dir>]"

help_usage "$@"

dir="${1:-.}"

cd "$dir"

policy_arn_mapping="$(aws iam list-policies | jq -r '.Policies[] | [.PolicyName, .Arn] | @tsv' | column -t)"

terraform plan -no-color |
sed -n '/# aws_iam_policy\..* will be created/,/}/ p' |
awk '/# aws_iam_policy/ {print $2};
     /name/ {print $4}' |
sed 's/^"//; s/"$//' |
xargs -n2 echo |
sed 's/\[/["/; s/\]/"]/' |
while read -r policy name; do
    [ -n "$name" ] || continue
    timestamp "Importing policy: $name"
    arn="$(awk "/^${name}[[:space:]]/{print \$2}" <<< "$policy_arn_mapping")"
    if is_blank "$arn"; then
        die "Failed to determine policy ARN"
    fi
    cmd=(terraform import "$policy" "$arn")
    timestamp "${cmd[*]}"
    if [ -z "${TERRAFORM_PRINT_ONLY:-}" ]; then
        "${cmd[@]}"
    fi
    echo >&2
done
