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
Lists all running non-replica Cloud SQL instance names

Useful to get a list to iterate on for backups, exports, grants etc.

Used by adjacent scripts:

    gcp_sql_export.sh
    gcp_sql_grant_instances_gcs_object_creator.sh
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

# XXX: only running instances can do exports, otherwise will error out
# XXX: only non-replicas back up correctly due to conflicts with ongoing replication recovery operations - see description above for details
# gcloud sql instances list --format='get(name)' --filter 'STATUS=runnable' | grep -v -- '-replica$'
# better to not rely on the name having a '-replica' suffix and instead use the JSON instanceType field to exclude replicas
gcloud sql instances list --format=json | jq -r '.[] | select(.instanceType != "READ_REPLICA_INSTANCE") | select(.state == "RUNNABLE") | .name'
