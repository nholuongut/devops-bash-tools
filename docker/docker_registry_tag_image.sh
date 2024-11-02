#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: localhost:5000 centos nholuonguttest
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Tags a given image in a Docker Registry with another tag via the Docker Registry API v2
without pulling and pushing the data (much faster and more efficient)

If :<tag> isn't given, assumes 'latest'

See adjacent docker_api.sh for authentication details
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="http(s)://host:port <image>[:<tag>] <new_tag>"

help_usage "$@"

min_args 3 "$@"

docker_registry_url="$1"
image_tag="$2"
new_tag="$3"
shift || :
shift || :
shift || :

if ! [[ "$docker_registry_url" =~ ^(https?://)?[[:alnum:].-]+:[[:digit:]]+/?$ ]]; then
    usage "invalid docker registry url: $docker_registry_url"
fi

if ! [[ "$docker_registry_url" =~ ^https?:// ]]; then
    docker_registry_url="http://$docker_registry_url"
fi

image="${image_tag%%:*}"
tag="${image_tag##*:}"
if ! [[ "$image_tag" =~ : ]] &&
   [ "$tag" = "$image" ]; then
    tag="latest"
fi

manifest="$("$srcdir/docker_registry_get_image_manifest.sh" "$docker_registry_url" "$image_tag")"

"$srcdir/docker_api.sh" "$docker_registry_url/v2/$image/manifests/$new_tag" -X PUT -d "$manifest" -H "Content-Type: application/vnd.docker.distribution.manifest.v2+json"
