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
Lists GCP service account members eg. to find GKE Workload Identity integrations

Output:

    <service_account>   <role>  <member>

eg.

    jenkins-agent@MyProject.iam.gserviceaccount.com      roles/iam.workloadIdentityUser  serviceAccount:MyProject.svc.id.goog[jenkins/jenkins-agent]
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<project_id>]"

help_usage "$@"

if [ $# -eq 1 ]; then
    export CLOUDSDK_CORE_PROJECT="$1"
elif [ $# -eq 0 ]; then
    :
else
    usage
fi

serviceaccounts="$(gcloud iam service-accounts list --format='value(name.basename())')"

for serviceaccount in $serviceaccounts; do
    gcloud iam service-accounts get-iam-policy "$serviceaccount" --format json |
    jq -r "
        .bindings[]? |
        { \"role\": .role, \"member\": .members[] } |
        [ \"$serviceaccount\", .role, .member ] |
        @tsv
    "
done
