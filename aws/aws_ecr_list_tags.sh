#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: nholuonguttest:1.0 stable


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists all tags for the given AWS ECR docker image

Each tag for the given image is output on a separate line for easy further piping and filtering


$usage_aws_cli_required


Similar scripts:

    aws_ecr_*.sh - scripts for AWS Elastic Container Registry

    gcr_*.sh - scripts for Google Container Registry
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<image> [<aws_cli_options>]"

help_usage "$@"

min_args 1 "$@"

image="$1"
shift || :

aws ecr list-images --repository "$image" "$@" |
jq -r '.imageIds[].imageTag | select(.)' |
sort
