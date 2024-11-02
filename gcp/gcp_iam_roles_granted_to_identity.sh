#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Finds all roles in the given or current project which are assigned to any identity (user/group/serviceAccount) matching the given regex

For best matching the identity should be in the standard GCP format eg.

    user:nholuongut@mydomain.com

    group:platform-engineering@mydomain.com

    serviceAccount:myproject-gke-sa@myproject.iam.gserviceaccount.com
    serviceAccount:myproject@appspot.gserviceaccount.com

but is interpreted as a regex so you could just use a substring match like 'nholuongut' and that would find roles containing any users/groups/serviceAccounts with that string in them

    ${0##*/} nholuongut

You could also use this to find any roles granted on a user-basis against group-oriented policy eg.

    ${0##*/} ^user:

Find roles granted too widely to all authenticated users, searching across all your projects:

    ${0##*/} group:allAuthenticatedUsers all

Find roles granted too widely to all unauthenticated users, searching across all your projects:

    ${0##*/} group:allUsers all


Requires GCloud SDK to be installed and configured
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<identity_regex> [<project_id>]"

help_usage "$@"

min_args 1 "$@"

regex="$1"
project="${2:-}"

if is_blank "$regex"; then
    usage "identity regex cannot be blank"
fi

if is_blank "$project"; then
    project="$(gcloud config list --format='get(core.project)')"
fi

not_blank "$project" || die "ERROR: no project specified and GCloud SDK core.project property not set in config"

get_roles(){
    local project="$1"
    gcloud projects get-iam-policy "$project" --format=json |
    jq -r ".bindings[] | select(.members[] | test(\"$regex\")) | .role"
}

if [ "$project" = "all" ] ;then
    for project in $(gcloud projects list --format='get(project_id)'); do
        get_roles "$project"
    done
else
    get_roles "$project"
fi |
sort -u
