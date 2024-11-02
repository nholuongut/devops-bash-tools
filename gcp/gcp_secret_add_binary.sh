#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/gcp.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Adds a given binary file to GCP Secret Manager as base64

First argument is used as secret name
Second argument must be a binary file such as a QR Code screenshot - this is converted to base 64
Remaining args are passed directly to 'gcloud secrets'

Example:

    ${0##*/} mysecret qr-code-screenshot.png

# To retrieve the binary file back:

    gcp_secret_get.sh mysecret | base64 --decode > qr-code.png


$usage_gcloud_sdk_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<name> [<secret> <gcloud_options>]"

help_usage "$@"

min_args 2 "$@"

name="$1"
file="$2"
shift || :
shift || :

if ! [ -f "$file" ]; then
    die "File not found: $file"
fi

base64 "$file" |
gcloud secrets create "$name" --data-file - "$@"
