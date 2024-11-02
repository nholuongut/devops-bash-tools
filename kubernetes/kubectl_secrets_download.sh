#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Downloads all Kubernetes secrets in the current or given namespace to files in the local directory named secret-<name>.yaml

Useful for backing up all your live secrets before migrating to Sealed Secrets
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<kubectl_options>]"

help_usage "$@"

kubectl get secrets --no-headers -o custom-columns=":metadata.name" "$@" |
while read -r secret; do
    filename="secret-$secret.$(date '+%F_%H-%M-%S').yaml"
    timestamp "Downloading secret '$secret' to '$filename'"
    kubectl get secrets "$secret" "$@" -o yaml > "$filename"
done

echo "Done"
