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
Creates a GCP service account and exports a credentials key to Google Secret Manager

This is useful because it can be repeatedly sourced from there, eg. loaded to Kubernetes

Should use the service account's short name (the prefix before the @ symbol)

See Also:

    gcp_secrets_to_kubernetes.sh

Idempotent - skips service account creation if already exists and credential key export if already exists in Google Secret Manager
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<service_account_name> [<project> <description>]"

help_usage "$@"

min_args 1 "$@"

name="$1"
# will reconstruct the full id / service account email using the project and naming convention
name="${name%%@*}"

# XXX: sets the GCP project for the duration of the script for consistency purposes (relying on gcloud config could lead to race conditions)
project="$(gcloud config list --format='get(core.project)' || :)"
export CLOUDSDK_CORE_PROJECT="${CLOUDSDK_CORE_PROJECT:-$project}"
not_blank "$CLOUDSDK_CORE_PROJECT" || die "ERROR: \$CLOUDSDK_CORE_PROJECT / GCloud SDK config core.project value not set"

description="${3:-}"

keyfile="/tmp/$name-$project-credential.json.$$"
trap_cmd "rm -f -- '$keyfile'"

service_account="$name@$project.iam.gserviceaccount.com"

if gcloud iam service-accounts list --format='get(email)' | grep -Fxq "$service_account"; then
    timestamp "Service account '$service_account' already exists"
else
    timestamp "Creating service account '$name' in project '$project'"
    gcloud iam service-accounts create "$name" --description="$description"
fi

secret_name="${name}-credential"
if gcloud secrets list --format='value(name)' | grep -Fxq "$secret_name"; then
    timestamp "GCP Secret '$secret_name' already exists"
else
    timestamp "Exporting service account '$name' credential key to GCP Secret '$secret_name' in project '$project'"
    gcloud iam service-accounts keys create "$keyfile" --iam-account="$service_account" --key-file-type="json"
    gcloud secrets create "$secret_name" --data-file="$keyfile"
fi
