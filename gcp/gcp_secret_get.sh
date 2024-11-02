#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/gcp.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Finds the latest version of a given GCP Secret Manager secret and fetches its value

First argument is used as secret name - if not given prompts for it
Second or more args are passed to 'gcloud secrets'


$usage_gcloud_sdk_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<name>"

help_usage "$@"

num_args 1 "$@"

name="$1"

latest_version="$(
    gcloud secrets versions list "$name" --filter='state = enabled' --format='value(name)' |
    sort -k1nr |
    head -n1
)"

gcloud secrets versions access "$latest_version" --secret="$name"
