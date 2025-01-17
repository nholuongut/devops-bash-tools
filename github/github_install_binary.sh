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
Installs a GitHub repo's release binary to \$HOME/bin or /usr/local/bin, unpacking it from a tarball or zip if necessary

If the release file is a tarball or zip file then it'll auto-unpack it, but you must specify the path to the binary in the unpack

If version is not specified, determine the latest release and installs that

If the release URL title/path is more complicated than the convention of following the version number, such as is the case for Kustomize, then you'd need to call install_binary.sh with the URL path instead of using this script, see setup/install_kustomize.sh
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<owner>/<repo> <release_file_tarball_zip> [<version> <path/to/unpacked/binary> <install_path>]"

export PATH="$PATH:$HOME/bin"

help_usage "$@"

min_args 2 "$@"

owner_repo="$1"

release_file="$2"

version="${3:-latest}"

binary="${4:-}"

install_path="${5:-}"

if [ "$version" = latest ]; then
    timestamp "determining latest version of '$owner_repo' via GitHub API"
    version="$("$srcdir/github_repo_latest_release.sh" "$owner_repo")"
    timestamp "latest version is '$version'"
else
    is_semver "$version" || die "non-semver version argument given: '$version' - should be in format: N.N.N"
fi

release_file="${release_file//\{version\}/${version#v}}"
binary="${binary//\{version\}/${version#v}}"

"$srcdir/../packages/install_binary.sh" "https://github.com/$owner_repo/releases/download/$version/$release_file" ${binary:+"$binary"} ${install_path:+"$install_path"}
