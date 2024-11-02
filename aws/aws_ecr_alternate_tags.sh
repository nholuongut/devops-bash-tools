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
Lists all alternative tags for the given specific GCR docker image:tag

If a container has multiple tags (eg. latest, v1, hashref), you can supply '<image>:latest' to see which version has been tagged to 'latest'

Each tag for the given <image>:<tag> is output on a separate line for easy further piping and filtering, including the originally supplied tag

If no tag is given, assumes 'latest'

If the image isn't found in GCR, will return nothing and no error code since this is the default GCloud SDK behaviour

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
    tag="latest"
fi

aws ecr describe-images --repository-name "$image" --image-ids "imageTag=$tag" "$@" |
jq -r '.imageDetails[].imageTags[]' |
sort
