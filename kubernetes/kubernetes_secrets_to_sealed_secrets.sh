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
Creates Kubernetes sealed secrets from all Kubernetes secrets in the current or given namespace

Iterates all non-service-account-token secrets, and for each one:

    - generates sealed secret yaml
    - annotates existing secret to be able to be managed by sealed secrets
    - creates sealed secret in the same namespace

Useful to migrate existing secrets to sealed secrets which are safe to commit to Git

Use kubectl_secrets_download.sh to take a backup of secrets first

XXX: you should probably omit committing secrets generated by Cert Manager (eg. *-tls)


Requires kubectl and kubeseal to both be in the \$PATH and configured
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<namespace> <context>]"

help_usage "$@"

#min_args 1 "$@"

namespace="${1:-}"
context="${2:-}"

kube_config_isolate

if [ -n "$context" ]; then
    kube_context "$context"
fi
if [ -n "$namespace" ]; then
    kube_namespace "$namespace"
fi

kubectl get secrets |
# don't touch the default generated service account tokens for safety
grep -v kubernetes.io/service-account-token |
# remove header
grep -v '^NAME[[:space:]]' |
awk '{print $1}' |
while read -r secret; do
    "$srcdir/kubernetes_secret_to_sealed_secret.sh" "$secret" ${namespace:+"$namespace"} ${context:+"$context"}
    echo
done

echo "Completed. Don't forget to commit all sealed-secrets-*.yaml to Git"
