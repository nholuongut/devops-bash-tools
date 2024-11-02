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
Returns all secrets that have the annotation sealedsecrets.bitnami.com/managed=\"true\" set, ie. waiting to be replaced by Bitnami Sealed Secrets

Useful to track progress in migrations to Sealed Secrets

See Also:

    kubernetes_secrets_to_sealed_secrets.sh - sets the annotation for the secret to be overwritten

Requires kubectl to be install in the \$PATH and configured with the right context
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<kubectl_options>"

help_usage "$@"

"$srcdir/kubectl_get_annotation.sh" secrets sealedsecrets.bitnami.com/managed '"true"' "$@"
