#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args:
#  args: :org


# https://www.terraform.io/cloud-docs/api-docs/workspaces

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists Terraform Cloud workspaces for a given organization

See terraform_cloud_organizations.sh to get a list of organization IDs
See terraform_cloud_varsets.sh to get a list of workspaces and their IDs


Output:

<id>    <name>
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<organization>]"

help_usage "$@"

#min_args 1 "$@"

org="${1:-${TERRAFORM_ORGANIZATION:-}}"

if [ -z "$org" ]; then
    usage "no terraform organization given and TERRAFORM_ORGANIZATION not set"
fi

# TODO: add pagination support
"$srcdir/terraform_cloud_api.sh" "/organizations/$org/workspaces" |
jq_debug_pipe_dump |
jq -r '.data[] | [.id, .attributes.name] | @tsv'
