#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/../lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Installs Kubeseal for Bitnami Sealed Secrets
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<version>]"

export PATH="$PATH:$HOME/bin"

help_usage "$@"

#version="${1:-0.18.1}"
version="${1:-latest}"

export RUN_VERSION_OPT=1

"$srcdir/../github/github_install_binary.sh" bitnami-labs/sealed-secrets "kubeseal-{version}-{os}-{arch}.tar.gz" "$version" kubeseal
