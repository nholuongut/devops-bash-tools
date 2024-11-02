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
Lists Kubernetes nodes and their labels, one per line (more convenient for shell piping)

Output Format:

<node_name>     <label_key>=<label_value>
<node_name>     <label_key2>=<label_value2>
<node_name2>     <label_key>=<label_value>
...


This format is much easier to read and work with while scripting than the single line monstrocity returned by:

    kubectl get nodes --show-labels


Requires kubectl to be installed and configured


If you only want to see a a list of unique available labels:

    ${0##*/} | awk '{print \$2}' | sort -u
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

kube_config_isolate

kubectl get nodes -o json |
jq -r '
    .items[] |
    { "name": .metadata.name, "label": .metadata.labels | to_entries[] } |
    select(.label) |
    [ .name, .label.key + "=" + .label.value ] |
    @tsv
' |
sort -k1,2
