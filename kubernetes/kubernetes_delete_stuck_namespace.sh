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
Forcibly deletes a Kubernetes namespace that is stuck deleting

Written to get rid of Knative namespaces knative-eventing, knative-serving and kourier-system which were all permanently stuck trying to delete

Doesn't do the actual deletion of the namespace, but deletes the finalizers to allow a namespace already stuck in deletion to be removed

WARNING: do not run this on a normal healthy namespace that you care about, as it will wipe out the finalizers

Various solutions to this problem can be found here:

    https://stackoverflow.com/questions/52369247/namespace-stuck-as-terminating-how-i-removed-it
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<namespace>"

help_usage "$@"

min_args 1 "$@"

namespace="$1"

timestamp "Stuck resources in namespace '$namespace':"
kubectl api-resources --verbs=list --namespaced -o name |
xargs -n 1 kubectl get --show-kind --ignore-not-found -n "$namespace"

echo

timestamp "Attempting to remove the finalizers:"
kubectl get namespace "$namespace" -o json |
tr -d "\n" |
sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/" |
kubectl replace --raw "/api/v1/namespaces/$namespace/finalize" -f -
