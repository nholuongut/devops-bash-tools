#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  
# https://www.jetbrains.com/help/teamcity/rest-api-reference.html#VCS+Roots

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Creates a TeamCity VCS root from a saved configuration file (XML or JSON)

The config file is the same format as downloaded by the adjacent script:

    teamcity_vcs_roots_download.sh

but you will need to add the password back in to the file before upload (can be blank and set later in UI)


Unfortunately TeamCity doesn't allow creating VCS roots using say the GitHub OAuth connection via the API,
or at least I can find no reference to how to do this - so you might still need to create those type of VCS roots
by hand or else switch to using another mechanism like SSH keys


Uses the adjacent teamcity_api.sh

See teamcity_api.sh for required connection settings and authentication
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<vcs_root_config_file>"

help_usage "$@"

min_args 1 "$@"

config="$1"
shift || :

if ! [ -s "$config" ]; then
    die "ERROR: file not found or is empty: $config"
fi

opts=()

shopt -s nocasematch
if [[ "$config" =~ \.xml$ ]]; then
    # teamcity_api.sh defaults to JSON
    opts+=(-H "Accept: application/xml" -H "Content-Type: application/xml")
else
    vcs_id="$(jq -r .id < "$config")"
    if "$srcdir/teamcity_vcs_roots.sh" | grep -qi "^${vcs_id}[[:space:]]"; then
        timestamp "VCS root '$vcs_id' already exists, skipping creation"
        exit 0
    fi
fi
shopt -u nocasematch

timestamp "creating TeamCity VCS root from '$config'"
# create VCS root from given configuration
"$srcdir/teamcity_api.sh" "/vcs-roots" \
    -X POST \
    -d @"$config" \
    "${opts[@]:-}"
echo
