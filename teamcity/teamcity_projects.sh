#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#

# https://www.jetbrains.com/help/teamcity/rest-api-reference.html#project+Configuration+And+Template+Settings

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists TeamCity Projects - useful to find the IDs needed to download specific projects using teamcity_projects_download.sh

Output Format:

<project_id>    <project_name>

Uses the adjacent teamcity_api.sh and jq (installed by 'make')

See teamcity_api.sh for required connection settings and authentication
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

#min_args 1 "$@"

"$srcdir/teamcity_api.sh" /projects |
jq -r '.project[] | [.id, .name] | @tsv'
