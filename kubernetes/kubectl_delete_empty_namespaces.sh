#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/kubernetes.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Finds empty namespaces in the current Kubernetes cluster context and deletes them

Uses adjacent script kubectl_empty_namespaces.sh

Kubectl must be installed and configured
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

kube_config_isolate

"$srcdir/kubectl_empty_namespaces.sh" |
while read -r namespace; do
    timestamp "Deleting empty namespace '$namespace'"
    kubectl delete namespace "$namespace"
done
