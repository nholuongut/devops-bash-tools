#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: localhost:5000 centos
#  args: https://hub.docker.com centos
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists tags for a given Docker Registry image using the Docker Registry API

Example:

    ${0##*/} localhost:5000 centos

    ${0##*/} localhost:5000 ubuntu

    ${0##*/} localhost:5000 nholuongut/hbase

    ${0##*/} https://hub.docker.com centos

    ${0##*/} https://hub.docker.com ubuntu

    ${0##*/} https://hub.docker.com nholuongut/hbase


If the registry given is hub.docker.com, calls dockerhub_list_tags.sh
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="https://host:port <image> [<curl_options>]"

help_usage "$@"

min_args 2 "$@"

registry="$1"
image="$2"
shift || :
shift || :

if [[ "$registry" =~ hub.docker.com ]]; then
    # calling this unifies the logic around prefixing library/ to official images and takes care of the differing paths between Docker Registry API and DockerHub APIs
    exec "$srcdir/dockerhub_list_tags.sh" "$image" "$@"
fi

# now we only have to deal with Docker Registry API
url="$registry/v2/$image/tags/list"

"$srcdir/docker_api.sh" "$url" "$@" |
jq -r '.tags[]'
