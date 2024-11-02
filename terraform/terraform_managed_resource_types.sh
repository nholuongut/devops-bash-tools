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
Quick Terraform code parser of the given or current directory tree to list all the resources types found in Terraform *.tf code files

Useful to give you a quick glance of what services you are managing. Usually you're want to run this at the top of your Terraform repo

Caveat: won't return anything from modules outside your current or given directory tree, or any resources created by external referenced modules
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<dir>]"

help_usage "$@"

#min_args 1 "$@"

dir="${1:-.}"

find "$dir" -type f -iname '*.tf' -print0 |
xargs -0 grep -hR '^[[:space:]]*resource' |
awk '/^[[:space:]]*resource[[:space:]]/{print $2}' |
sed 's/^"//; s/"$//' |
sort -u
