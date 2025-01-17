#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


# https://kubernetes.io/docs/tasks/tools/install-kubectl/

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/../lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Installs Kubernetes 'kubectl' CLI
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<version>]"

export PATH="$PATH:$HOME/bin"

help_usage "$@"

#min_args 1 "$@"

version="${1:-latest}"

if [ "$version" = latest ]; then
    version="$(curl -sSL https://dl.k8s.io/release/stable.txt)"
    version="${version#v}"
    timestamp "latest version is '$version'"
else
    is_semver "$version" || die "non-semver version argument given: '$version' - should be in format: N.N.N"
fi

# gives this error:
# WARNING: This version information is deprecated and will be replaced with the output from kubectl version --short.  Use --output=yaml|json to get the full version.
# The connection to the server localhost:8080 was refused - did you specify the right host or port?
#export RUN_VERSION_ARG=1

"$srcdir/../packages/install_binary.sh" "https://dl.k8s.io/release/v$version/bin/{os}/{arch}/kubectl"

echo
if am_root; then
    /usr/local/bin/kubectl version --client --short
else
    ~/bin/kubectl version --client --short
fi
