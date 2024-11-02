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
Parses Terraform Plan for aws_ssoadmin_permission_set_inline_policy additions and imports each one into Terraform state

If \$TERRAFORM_PRINT_ONLY is set to any value, prints the commands to stdout to collect so you can check, collect into a text file or pipe to a shell or further manipulate, ignore errors etc.


Requires Terraform to be installed and configured
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<dir>]"

help_usage "$@"

dir="${1:-.}"

cd "$dir"

# would have to parse references, and then double parse to find the values of the object references :-/
#terraform show -json "$TMP_PLAN" |

terraform plan -no-color |
sed -n '/# aws_ssoadmin_permission_set_inline_policy\..* will be created/,/permission_set_arn/ p' |
awk '/# aws_ssoadmin_permission_set_inline_policy/ {print $2};
     /instance_arn|permission_set_arn/ {print $4}' |
sed 's/^"//; s/"$//' |
xargs -n3 echo |
sed 's/\[/["/; s/\]/"]/' |
while read -r name instance_arn permission_set_arn; do
    [ -n "$permission_set_arn" ] || continue
    timestamp "Importing $name"
    cmd=(terraform import "$name" "$permission_set_arn,$instance_arn")
    timestamp "${cmd[*]}"
    if [ -z "${TERRAFORM_PRINT_ONLY:-}" ]; then
        "${cmd[@]}"
    fi
    echo >&2
done
