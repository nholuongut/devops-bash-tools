#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/kubernetes.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists Kubernetes pods and their pod IPs, one per line (more convenient for shell piping)

Specify kubectl options like --namespace '...' or --all-namespaces are arguments like you normally would

Output Format:

<namespace>     <pod_name>     <ip>
<namespace>     <pod_name2>    <ip>
...


Requires kubectl to be installed and configured
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<kubectl_options>]"

help_usage "$@"

kube_config_isolate

kubectl get pods -o json "$@" |
jq -r '
    .items[] |
    [.metadata.namespace, .metadata.name, .status.podIP] |
    @tsv
' |
column -t
