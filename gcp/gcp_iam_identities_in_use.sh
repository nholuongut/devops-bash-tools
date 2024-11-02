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
Quick list of unique GCP IAM identities (users/groups/serviceAccounts) in use in the current GCP project or across all projects

You can optionally specify the GCP project, otherwise infers your currently set core.project

If you specify 'all' for project, will return a sorted superset list from all projects
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<project_id>]"

help_usage "$@"

#min_args 1 "$@"

project="${1:-}"

if is_blank "$project"; then
    project="$(gcloud config list --format='get(core.project)')"
fi

not_blank "$project" || die "ERROR: no project specified and GCloud SDK core.project property not set in config"

get_identities(){
    local project="$1"
    gcloud projects get-iam-policy "$project" --format=json |
    jq -r '.bindings[].members[]'
}

if [ "$project" = "all" ] ;then
    for project in $(gcloud projects list --format='get(project_id)'); do
        get_identities "$project"
    done
else
    get_identities "$project"
fi |
sort -u