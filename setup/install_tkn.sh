#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/../lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Installs Tekton CLI
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<version>]"

export PATH="$PATH:$HOME/bin"

help_usage "$@"

#version="${1:-2.4.0}"
version="${1:-latest}"

export OS_DARWIN=Darwin

if is_mac; then
    export ARCH_OVERRIDE=all
fi

export RUN_VERSION_ARG=1

package="tkn_{version}_{os}_{arch}.tar.gz"

"$srcdir/../github/github_install_binary.sh" tektoncd/cli "$package" "$version" tkn
