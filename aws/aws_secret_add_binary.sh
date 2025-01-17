#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Adds a given binary file to AWS Secrets Manager as base64 - this is only possible via the CLI or SDK as it's not supported in the AWS Console UI at this time

First argument is used as secret name
Second argument must be a binary file such as a QR Code screenshot - this is converted to base 64 because AWS only permits ASCII characters in this value
Remaining args are passed directly to 'aws secretsmanager'

Example:

    ${0##*/} mysecret qr-code-screenshot.png

# To retrieve the binary file back:

    aws_secret_get.sh mysecret | base64 --decode > qr-code.png


Caveat: your QR pic cannot be too big or complex or it'll result in too large a base64 string which gives this error:

    An error occurred (ValidationException) when calling the CreateSecret operation: 1 validation error detected: Value at 'secretBinary' failed to satisfy constraint: Member must have length less than or equal to 65536

Workaround: instead of screenshotting, save the QR code png via right-click download, it'll result in a much smaller original png download which will be able to be saved to AWS Secrets Manager


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<name> <file> [--description 'QR Code for GitHub Account' <aws_options>]"

help_usage "$@"

min_args 2 "$@"

name="$1"
file="$2"
shift || :
shift || :

if ! [ -f "$file" ]; then
    die "File not found: $file"
fi

aws secretsmanager create-secret --name "$name" --secret-binary "$(base64 "$file")" "$@"
