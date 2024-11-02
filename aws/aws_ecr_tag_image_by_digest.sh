#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: nholuonguttest:1.0 stable

# https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-retag.html

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Tags an AWS ECR image digest with another tag without pulling + pushing the image

Useful to recover an <untagged> image and apply a new tag to it or if you want to more precisely tag an exact image than following another existing tag (which is usually easier but can be a moving target)

If the environment variable FORCE is set, will remove the new tag reference to ensure the new tagging takes effect

$usage_aws_cli_required


Similar scripts:

    aws_ecr_tag_image.sh - same as this script but locates the image using an existing tag

    docker_registry_tag_image.sh - for private Docker Registries

    gcr_*.sh - scripts for Google Container Registry
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<image> <digest> <new_tag> [<aws_cli_options>]"

help_usage "$@"

min_args 3 "$@"

image="$1"
digest="$2"
new_tag="$3"

if ! [[ "$digest" =~ : ]]; then
    digest="sha256:$digest"
fi

tstamp "getting manifest for image '$image' with digest '$digest'"
manifest="$(aws ecr batch-get-image --repository-name "$image" --image-ids "imageDigest=$digest" --query 'images[].imageManifest' --output text "$@")"
if is_blank "$manifest"; then
    die "ERROR: no manifest returned, did you specify a valid digest?"
fi

if [ -n "${FORCE:-}" ]; then
    "$srcdir/aws_ecr_delete_tag.sh" "$image:$new_tag" "$@" >/dev/null || :
fi
tstamp "tagging image '$image' with digest '$digest' with new tag '$new_tag'"
aws ecr put-image --repository-name "$image" --image-tag "$new_tag" --image-manifest "$manifest" "$@" >/dev/null

tstamp "tags for image '$image' with digest '$digest' are now:"
aws ecr describe-images --repository-name "$image" --output json "$@" |
jq -r ".imageDetails[] | select(.imageDigest) | select(.imageDigest == \"$digest\") | .imageTags[]"
