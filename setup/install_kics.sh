#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/../lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Installs Kics 1.5.1 (the last version to support downloadable binaries)

It's recommended to use the docker image instead now
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<version>]"

help_usage "$@"

#min_args 1 "$@"

# the last version to support downloadable binaries
version="${1:-1.5.1}"

owner_repo="Checkmarx/kics"

if [ "$version" = latest ]; then
    timestamp "determining latest version of '$owner_repo' via GitHub API"
    version="$("$srcdir/../github/github_repo_latest_release.sh" "$owner_repo")"
    timestamp "latest version is '$version'"
    version="${version#v}"
else
    is_semver "$version" || die "non-semver version argument given: '$version' - should be in format: N.N.N"
fi

os="$(get_os)"
arch="$(get_arch)"
if [ "$arch" = "amd64" ]; then
    arch="x64"
fi

# tarballs unpacks locally so create dir
installdir=~/bin/"kics_${version}"

mkdir -pv "$installdir"

cd "$installdir"

tarball="kics_${version}_${os}_$arch.tar.gz"

# wget isn't available on GCloud SDK container
curl -sSLf -o "$tarball" "https://github.com/Checkmarx/kics/releases/download/v$version/$tarball"
echo

echo "unpacking tarball to: $PWD"
tar zxf "$tarball"
echo

echo "removing tarball:"
rm -fv -- "$tarball"
echo

echo "symlinking install dir:"
ln -sfhv -- "$installdir" ~/bin/kics ||
# GCloud SDK version of 'ln' command doesn't have the -h switch
ln -sfv -- "$installdir" ~/bin/kics
echo

echo "Ensure $HOME/bin/kics is added to your \$PATH"
