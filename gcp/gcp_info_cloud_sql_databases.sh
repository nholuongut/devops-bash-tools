#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/gcp.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists GCP Cloud SQL databases on each SQL instance in the current GCP Project

Only works on running instances since it requires querying the DB. We skip non-running instances as otherwise the GCloud SDK errors out

Can optionally specify a project id using the first argument, otherwise uses currently configured project

$gcp_info_formatting_help
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<project_id>]"

help_usage "$@"

check_bin gcloud

if [ $# -gt 0 ]; then
    project_id="$1"
    shift || :
    export CLOUDSDK_CORE_PROJECT="$project_id"
fi


# shellcheck disable=SC1090,SC1091
type is_service_enabled &>/dev/null || . "$srcdir/gcp_service_apis.sh" >/dev/null


cat <<EOF
# ============================================================================ #
#                     C l o u d   S Q L   D a t a b a s e s
# ============================================================================ #

EOF

# might need this one instead sqladmin.googleapis.com
if is_service_enabled sql-component.googleapis.com; then
    gcloud sql instances list --format='get(name)' --filter 'state = RUNNABLE' |
    while read -r instance; do
        gcp_info "Cloud SQL databases for instance '$instance'" gcloud sql databases list --instance "$instance"
    done
else
    echo "Cloud SQL API (sql-component.googleapis.com) is not enabled, skipping..."
fi
