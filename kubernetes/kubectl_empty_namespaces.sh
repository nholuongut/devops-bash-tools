#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
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
Finds empty namespaces in the current Kubernetes cluster context

Outputs empty namespaces one per line to stdout, while outputting timestamped progress to stderr, so stdout can still be
passed straight in a command pipe to act on those namespaces

Used by adjacent script kubectl_delete_empty_namespaces.sh

Kubectl must be installed and configured
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

kube_config_isolate

timestamp "Getting list of namespaces"
#kubectl get ns -o name |
#sed 's|namespace/||' |
kubectl get namespaces -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' |
while read -r namespace; do
    if [[ "$namespace" =~ ^kube- ]]; then
        continue
    fi
    timestamp "Checking namespace '$namespace'"
    # quicker, but doesn't return all objects - should return the usual candidates though
    objects="$(kubectl get all -n "$namespace" -o name)"
    # slow but safer
    #objects="$("$srcdir/kubectl_get_all.sh" -n "$namespace" | sed 's/#.*//| /^[[:space:]]*$/d')"
    if [ -z "$objects" ]; then
        echo "$namespace"
    fi
done
