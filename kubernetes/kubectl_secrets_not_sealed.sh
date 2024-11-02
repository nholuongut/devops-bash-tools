#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Returns secrets not yet managed by Sealed Secrets by querying for secrets without an SealedSecret owner reference

Output:

<namespace>     <secret_name>


Kubectl and jq need to be installed in the \$PATH and kubectl configured with the right context
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<kubectl_options>"

help_usage "$@"

# can't decompose this line across lines unfortunately for clarity, fails to parse
# gets secrets with a SealedSecret owner
#kubectl get secrets -o jsonpath='{range .items[?(@.metadata.ownerReferences[*].kind == "SealedSecret")]}{.metadata.name}{"\n"}'

# secrets with no owner references at all
kubectl get secrets "$@" -o json |
jq -r '
    .items[] |
    select(.metadata.ownerReferences | not) |
    [.metadata.namespace, .metadata.name] |
    @tsv'

# secrets with metadata.ownerReferences that don't have a SealedSecret kind (TODO: this query needs more testing)
kubectl get secrets "$@" -o json |
jq -r '
    .items[] |
    select(.metadata.ownerReferences) |
    select(.metadata.ownerReferences[].kind == "SealedSecret" | not) |
    [.metadata.namespace, .metadata.name] |
    @tsv'
