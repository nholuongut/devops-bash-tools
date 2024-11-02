#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/git.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Queries the Drone.io API

Can specify \$CURL_OPTS for options to pass to curl, or pass them as arguments to the script

Automatically handles authentication via environment variable \$DRONE_TOKEN


Get your personal access token here:

    https://cloud.drone.io/account


API Reference:

    https://docs.drone.io/api/overview/


Examples:


# Get currently authenticated user:

    ${0##*/} /user


# List repos registered in Drone:

    ${0##*/} /user/repos


# List your Drone builds for a repo (case sensitive):

    ${0##*/} /repos/{owner}/{repo}/builds
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="/path [<curl_options>]"

url_base="https://cloud.drone.io/api"

help_usage "$@"

min_args 1 "$@"

curl_api_opts "$@"

url_path="$1"
shift || :

url_path="${url_path##*:\/\/cloud.drone.io\/api}"
url_path="${url_path##/}"
url_path="${url_path##api}"

export TOKEN="$DRONE_TOKEN"

# this trick doesn't work, file descriptor is lost by next line
#filedescriptor=<(cat <<< "Private-Token: $DRONE_TOKEN")
# this works
#curl "${CURL_OPTS[@]}" -H @<(cat <<< "Authorization: Bearer $DRONE_TOKEN") "$url_base/$url_path" "$@"

"$srcdir/../bin/curl_auth.sh" "$url_base/$url_path" "${CURL_OPTS[@]}" "$@"
