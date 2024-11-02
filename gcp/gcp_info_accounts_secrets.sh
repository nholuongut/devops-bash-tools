#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/gcp.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists GCP IAM Service Accounts & Secrets Manager secrets deployed in the current GCP Project

Lists in this order:

    - IAM Service Accounts
    - Secrets Manager secrets

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


# Service Accounts
cat <<EOF
# ============================================================================ #
#                        S e r v i c e   A c c o u n t s
# ============================================================================ #

EOF

gcp_info "Service Accounts" gcloud iam service-accounts list


cat <<EOF


# ============================================================================ #
#                         I A M   P e r m i s s i o n s
# ============================================================================ #

EOF

"$srcdir/gcp_iam_roles_granted_too_widely.sh"


# Secrets
cat <<EOF


# ============================================================================ #
#                                 S e c r e t s
# ============================================================================ #

EOF

if is_service_enabled secretmanager.googleapis.com; then
    gcp_info "GCP Secrets" gcloud secrets list
else
    echo "Secrets Manager API (secretmanager.googleapis.com) is not enabled, skipping..."
fi
