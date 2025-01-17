#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/gcp.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Creates a GCP service account for Terraform deployments in the current or specified GCP project, then
creates and downloads the credentials json and even prints the command to configure your environment to start using Terraform immediately:

export GOOGLE_CREDENTIALS=\$HOME/.gcloud/\$name-\$project-credential.json

The following optional arguments can be given:

- service account name prefix   (default: \$USER-terraform)
- credential file path          (default: \$HOME/.gcloud/\$name-\$project-credential.json)
- project                       (default: \$CLOUDSDK_CORE_PROJECT or gcloud config's currently configured project setting core.project)

Idempotent - safe to re-run, will skip service accounts and keyfiles that already exist
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<name> <credential.json> <project>]"

help_usage "$@"

#min_args 1 "$@"

name="${1:-$USER-terraform}"

# XXX: sets the GCP project for the duration of the script for consistency purposes (relying on gcloud config could lead to race conditions)
project="${3:-${CLOUDSDK_CORE_PROJECT:-$(gcloud config list --format='get(core.project)')}}"

not_blank "$project" || die "ERROR: no project specified and \$CLOUDSDK_CORE_PROJECT / GCloud SDK config core.project value not set"
export CLOUDSDK_CORE_PROJECT="$project"

keyfile="${2:-$HOME/.gcloud/$name-$project-credential.json}"

gcp_create_serviceaccount_if_not_exists "$name" "$project" "$USER's service account for Terraform deployments"

service_account="$name@$project.iam.gserviceaccount.com"

gcp_create_credential_if_not_exists "$service_account" "$keyfile"

echo "Granting Owner permissions to service account '$service_account' on project '$project'"
# some projects may require --condition=None in non-interactive mode
gcloud projects add-iam-policy-binding "$project" --member="serviceAccount:$service_account" --role=roles/owner --condition=None >/dev/null

keyfile="$(readlink -e "$keyfile")"

echo
echo "Set this in your environment to use Terraform now:"
echo
echo "export GOOGLE_CREDENTIALS=$keyfile"
echo
