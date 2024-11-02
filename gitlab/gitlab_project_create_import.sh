#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Creates a GitLab project (repo) as a mirror import from another repo URL

If on GitLab Premium will configure auto-mirroring to stay in-sync too (can only manually configure for public repos on free tier, API doesn't support configuring even public repos on free)

URL can contain authentication information in the form:

    https://<username>:<password>@<url>/<owner>/<repo>
eg.
    ${0##*/} devops-bash-tools https://nholuongut:mypass@github.com/nholuongut/devops-bash-tools
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<project_name> <repo_url_to_mirror>"

help_usage "$@"

name="$1"
import_url="$2"

#if [ -n "${GITLAB_USER:-}" ]; then
#    user="$GITLAB_USER"
#else
#    # get currently authenticated user
#    user="$("$srcdir/gitlab_api.sh" /user | jq -r .username)"
#fi

#user="$("$srcdir/gitlab_api.sh" "/users?username=$user" | jq -r '.[0].id')"

timestamp "Creating GitLab repo '$name'"
#"$srcdir/gitlab_api.sh" "/projects/user/$user" -X POST \
# this will mirror automatically on Premium
"$srcdir/gitlab_api.sh" "/projects" -X POST \
    -d "{
    \"name\": \"$name\",
    \"import_url\": \"$import_url\",
    \"mirror\": true
}"
echo >&2

# not needed, create mirror option does the same
# XXX: only available in Premium unfortunately
#timestamp "Configuring repo mirroring from '$import_url'"
#"$srcdir/gitlab_api.sh" "/projects/$user/$name/mirror/pull" -X POST \
#    -d "{
#    \"import_url\": \"$import_url\",
#    \"mirror\": true
#}"
