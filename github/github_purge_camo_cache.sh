#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/github.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Purges all GitHub camo caches for things like CI/CD badges

If no owner/repo arg is given, attempts to determine the GitHub repo from the current git repo's origin

https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/about-anonymized-urls#removing-an-image-from-camos-cache
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<owner>/<repo>]"

help_usage "$@"

#min_args 1 "$@"
max_args 1 "$@"

if [ $# -gt 0 ]; then
    owner_repo="$1"
else
    if is_github_origin; then
        owner_repo="$(github_origin_owner_repo)"
    else
        usage "no <owner>/<repo> arg given and current directory doesn't appear to be a GitHub clone to auto-determine it"
    fi
fi

if ! is_github_owner_repo "$owner_repo"; then
	usage "Invalid owner/repo given: $owner_repo"
fi

url="https://github.com/$owner_repo"

timestamp "Fetching: $url"
curl -sL "$url" |
grep -Eo '<img src="https?://camo.githubusercontent.com/[^"]+' |
sed -e 's/<img src="//' |
while read -r camo_url; do
    timestamp "Purging: $camo_url"
    echo "curl -sX PURGE '$camo_url' &>/dev/null"
done |
parallel -j 10
