#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Tags a given AWS ECR docker image:tag as 'latest' without pulling and pushing the docker image


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

if ! [[ "$image_tag" =~ : ]]; then
    usage "tag suffix missing from docker image"
fi

docker_image="${image_tag%%:*}"
tag="${image_tag##*:}"
if is_blank "$tag"; then
    usage "tag suffix is blank"
fi

FORCE=1 "$srcdir/aws_ecr_tag_image.sh" "$docker_image:$tag" "latest" "$@"
