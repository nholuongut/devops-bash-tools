#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Uploads a given binary file as base64 to an existing AWS Secrets Manager secret - this is only possible via the CLI or SDK as it's not supported in the AWS Console UI at this time

First argument is used as secret name
Second argument must be a binary file such as a QR Code screenshot - this is converted to base 64 because AWS only permits ASCII characters in this value
Remaining args are passed directly to 'aws secretsmanager'

Example:

    ${0##*/} mysecret qr-code-screenshot.png

# To retrieve the binary file back:

    aws_secret_get.sh mysecret | base64 --decode > qr-code.png


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<name> <file> [--description 'My changed description' <aws_options>]"

help_usage "$@"

min_args 2 "$@"

name="$1"
file="$2"
shift || :
shift || :

if ! [ -f "$file" ]; then
    die "File not found: $file"
fi

# put-secret doesn't allow changing the --description or other details
aws secretsmanager update-secret --secret-id "$name" --secret-binary "$(base64 "$file")" "$@"
