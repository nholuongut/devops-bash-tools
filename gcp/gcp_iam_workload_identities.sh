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
List GCP Workload Identity service account integrations

Uses adjacent script gcp_iam_serviceaccount_members.sh, see there for output format
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<project_id>]"

help_usage "$@"

"$srcdir/gcp_iam_serviceaccount_members.sh" "$@" |
grep roles/iam.workloadIdentityUser
