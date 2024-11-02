#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/gcp.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Updates GCP Secrets in current project with a matching metadata label key=value to a new value

Used this to track Kubernetes cluster and namespace in GCP Secrets metadata in combination with
gcp_secrets_to_kubernetes.sh

This script is useful for say bulk moving secrets to a new namespace by updating all the kubernetes-namespace labels:

    ${0##*/} kubernetes-namespace <oldname> <newname>


Requires GCloud SDK to be installed and configured

See Also:

    gcp_secrets_labels.sh - lists labels one per line to review before/after mass changing label values
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<label_key> <old_value> <new_value>"

help_usage "$@"

min_args 3 "$@"

label_key="$1"
old_value="$2"
new_value="$3"

gcloud_export_active_configuration

export CLOUDSDK_CORE_PROJECT="${CLOUDSDK_CORE_PROJECT:-$(gcloud info --format="get(config.project)")}"

secrets="$(gcloud secrets list --filter "labels.$label_key=$old_value" --format='value(name)')"

for secret in $secrets; do
    gcloud secrets update "$secret" --update-labels "$label_key=$new_value"
done
