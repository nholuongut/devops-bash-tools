#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/gcp.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Reads a value from the command line and saves it to GCP Secret Manager without echo'ing it on the screen

First argument is used as secret name
Second argument is used as secret string value
    - if this argument is a file, such as an SSH key, reads the file content and saves it as the secret value
    - if not given prompts for it with a non-echo'ing prompt (recommended for passwords)
Remaining args are passed directly to 'gcloud secrets'


$usage_gcloud_sdk_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<name> [<secret> <gcloud_options>]"

help_usage "$@"

min_args 1 "$@"

name="$1"
secret="${2:-}"
shift || :
shift || :

if [ -z "$secret" ]; then
    read_secret
    #if [ -f "$secret" ]; then
    #    read -p "Given secret has been found as a local filename, are you sure you want to add this file?" answer
    #    if ! is_yes "$answer"; then
    #        die 'Aborting...'
    #    fi
    #fi
fi

if [ -f "$secret" ]; then
    gcloud secrets create "$name" --data-file "$secret" "$@"
else
    gcloud secrets create "$name" --data-file - "$@" <<< "$secret"
fi
