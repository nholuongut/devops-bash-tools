#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Finds GCP service accounts without any remaining IAM permissions - useful to find and remove old serviceaccounts after 90 day unused IAM permissions clean out

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

get_unused_identities(){
    local project="$1"
    identities_in_use="$("$srcdir/gcp_iam_identities_in_use.sh" "$project" | grep '^serviceAccount:' | sed 's/^[^:]*://')"
    gcloud iam service-accounts list --format='get(email)' --project "$project" |
    while read -r email; do
        # don't include <project>@appspot.gserviceaccount.com, but this was manageable in console
        #if ! [[ "$email" =~ \.iam\.gserviceaccount\.com$ ]]; then
        #    continue
        #fi
        if ! grep -Fixq "$email" <<< "$identities_in_use"; then
            echo "$email"
        fi
    done

}

if [ "$project" = "all" ] ;then
    for project in $(gcloud projects list --format='get(project_id)'); do
        get_unused_identities "$project"
    done
else
    get_unused_identities "$project"
fi |
sort -u
