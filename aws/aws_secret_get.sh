#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Retrieves a secret value from a given AWS Secrets Manager secret name

First argument is used as secret name
Remaining args are passed directly to 'aws secretsmanager'

Will check for and output Secret String or Secret Binary

Example:

    ${0##*/} my-secret


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<name>"

help_usage "$@"

min_args 1 "$@"

name="$1"
shift || :

aws secretsmanager get-secret-value --secret-id "$name" "$@" |
jq -r 'if .SecretString then .SecretString else .SecretBinary end'
