#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: google-containers/busybox:latest
#  args: gcr.io/google-containers/busybox:latest

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/gcp.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Tags a given GCR docker image:tag with the current branch name without pulling and pushing the docker image


Similar scripts:

    aws_ecr_*.sh - scripts for AWS Elastic Container Registry

    gcr_*.sh - scripts for Google Container Registry


Requires GCloud SDK to be installed and configured
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[gcr.io/]<project_id>/<image>:<tag>"

help_usage "$@"

num_args 1 "$@"

image_tag="$1"

if ! [[ "$image_tag" =~ gcr\.io ]]; then
    image_tag="gcr.io/$image_tag"
fi

# $gcr_image_tag_regex is defined in lib/gcp.sh
# shellcheck disable=SC2154
if ! [[ "$image_tag" =~ ^$gcr_image_tag_regex$ ]]; then
    usage "unrecognized GCR image:tag name - should be in a format matching this regex: ^$gcr_image_tag_regex$"
fi

docker_image="${image_tag%%:*}"
tag="${image_tag##*:}"

# Jenkins provides GIT_BRANCH, TeamCity doesn't so normalize and determine it if not automatically set
if [ -z "${BRANCH_NAME:-}" ]; then
    BRANCH_NAME="${GIT_BRANCH:-$(git rev-parse --abbrev-ref HEAD)}"
fi
BRANCH_NAME="${BRANCH_NAME##*/}"

echo "tagging docker image $docker_image:$tag with branch '$BRANCH_NAME'"
# --quiet otherwise prompts Y/n which would hang build
gcloud container images add-tag --quiet "$docker_image:$tag" "$docker_image:$BRANCH_NAME"
