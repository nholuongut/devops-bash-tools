#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/../lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Installs GitHub CLI

Once installed, configure authentication by creating a Personal Access Token (PAT) here:

    https://github.com/settings/tokens

and then exporting that as an environment variable - either GH_TOKEN or GITHUB_TOKEN (the former has higher precedence so is recommended):

    export GH_TOKEN=...
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<version>]"

export PATH="$PATH:$HOME/bin"

help_usage "$@"

#version="${1:-2.4.0}"
version="${1:-latest}"

ext="tar.gz"

export ARCH_X86_64=amd64
export OS_DARWIN=macOS

if is_mac; then
    ext="zip"
fi

export RUN_VERSION_ARG=1

"$srcdir/../github/github_install_binary.sh" cli/cli "gh_{version}_{os}_{arch}.$ext" "$version" "gh_{version}_{os}_{arch}/bin/gh"
