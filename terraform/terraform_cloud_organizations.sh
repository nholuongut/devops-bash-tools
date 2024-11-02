#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args:
#
# 
# https://www.terraform.io/cloud-docs/api-docs/organizations

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists Terraform Cloud organization IDs (needed by many adjacent scripts)

Output:

<id>
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

#min_args 1 "$@"

# TODO: add pagination support
"$srcdir/terraform_cloud_api.sh" "/organizations" |
jq_debug_pipe_dump |
jq -r '.data[].id'
