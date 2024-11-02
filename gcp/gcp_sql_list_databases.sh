#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists Cloud SQL instances and their databases in the current GCP project

Can specify one or more Cloud SQL instances, otherwise finds and iterates all instances in the current project


Output Format:

<host_sql_instance>     <database_name>
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<sql_instance1> <sql_instance2> ...]"

help_usage "$@"

no_more_opts "$@"

sql_instances="$*"

if [ -z "$sql_instances" ]; then
    # XXX: can only list databases for running instances, otherwise:
    #      ERROR: (gcloud.sql.databases.list) HTTPError 400: Invalid request: Invalid request since instance is not running.
    sql_instances="$(gcloud sql instances list --format=json | jq -r '.[] | select(.state == "RUNNABLE") | .name')"
fi

for sql_instance in $sql_instances; do
    #gcloud sql databases list --instance="$sql_instance" --format='get(name)'
    gcloud sql databases list --instance="$sql_instance" --format='table[no-heading](instance, name)'
done
