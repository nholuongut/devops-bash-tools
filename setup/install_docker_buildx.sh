#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/../lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Installs Docker Buildx plugin to ~/.docker/cli-plugins
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<version>]"

help_usage "$@"

#min_args 1 "$@"

version="${1:-latest}"

owner_repo="docker/buildx"

if [ "$version" = latest ]; then
    timestamp "determining latest version of '$owner_repo' via GitHub API"
    version="$("$srcdir/../github/github_repo_latest_release.sh" "$owner_repo")"
    timestamp "latest version is '$version'"
else
    is_semver "$version" || die "non-semver version argument given: '$version' - should be in format: N.N.N"
    [[ "$version" =~ ^v ]] || version="v$version"
fi

install_dir=~/.docker/cli-plugins

mkdir -p -v "$install_dir"

"$srcdir/../github/github_install_binary.sh" docker/buildx "buildx-$version.{os}-{arch}" "$version" docker-buildx "$install_dir/docker-buildx"
