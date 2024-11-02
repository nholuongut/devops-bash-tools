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
Finds GCP IAM users which have been granted roles on an individual basis in the current or given GCP project

Useful to find best practice violations where users have been granted roles instead of group-based management

This is slightly more useful than the adjacent gcp_iam_roles_with_direct_user_grants.sh since this is listed in the GCP Console UI per user on the IAM permissions page


Requires GCloud SDK to be installed and configured
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<project_id>]"

help_usage "$@"

project="${1:-}"

if is_blank "$project"; then
    project="$(gcloud config list --format='get(core.project)')"
fi

not_blank "$project" || die "ERROR: no project specified and GCloud SDK core.project property not set in config"

gcloud projects get-iam-policy "$project" --format=json |
jq -r ".bindings[].members[] | select(test(\"^user:\"))" |
sort -u
