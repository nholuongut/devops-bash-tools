#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
On GKE prints the list of Kubernetes volumes to GCP persistent disk name mappings using kubectl

Any args are passed straight to kubectl as is

Output:

    <namespace>    <pvc_name>    <kubernetes_persistent_volume>    <gcp_persistent_disk>    <zone>

This is useful to investigate GCP disks when testing disk resizing

See Also:

    https://github.com/nholuongut/Kubernetes-templates

        storageclass-gcp-*-resizeable.yml

Kubectl is expect to be installed, configured and pointing to the correct cluster context
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<kubectl_args>]"

help_usage "$@"

# the spec line needs to be one line because newlines in the jsonpath come out literally
kubectl get pv "$@" -o jsonpath='
    {range .items[*]}
        {.spec.claimRef.namespace}{"\t"}{.spec.claimRef.name}{"\t"}{.metadata.name}{"\t"}{.spec.gcePersistentDisk.pdName}{"\t"}{.metadata.labels.failure-domain\.beta\.kubernetes\.io/zone}{"\n"}
    ' |
column -t
