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
Deletes a tag for the given AWS ECR docker image


$usage_aws_cli_required


Similar scripts:

    aws_ecr_*.sh - scripts for AWS Elastic Container Registry

    gcr_*.sh - scripts for Google Container Registry
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<image>:<tag> [<aws_cli_options>]"

help_usage "$@"

min_args 1 "$@"

image_tag="$1"
shift || :

image="${image_tag%%:*}"
tag="${image_tag##*:}"
if [ -z "$tag" ] || [ "$tag" = "$image" ]; then
    usage "tag not given"
fi

timestamp "deleting tag '$tag' for ECR image '$image'"
# negate the result of the pipe
aws ecr batch-delete-image --repository-name "$image" --image-ids "imageTag=$tag" "$@" |
if jq -e '.failures[0]'; then
    exit 1
fi
