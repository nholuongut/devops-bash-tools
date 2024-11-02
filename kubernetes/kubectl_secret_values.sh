#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Simply reads out and base64 decodes secret values to quickly debug them

Iterates each key within the Kubernetes secret and prints them line by line with their contained value

Output format:

<secret_key1>   <decoded_value>
<secret_key2>   <decoded_value>

Good counterpart to check on what has been auto-loaded from GCP Secret Manager
to Kubernetes secrets by gcp_secrets_to_kubernetes.sh

See Also:

    gcp_secrets_to_kubernetes.sh - loads from GCP Secret Manager to Kubernetes secret

    kubectl_kv_to_secret,sh - creates a Kuberbetes secret from key=value args or stdin, environment export commands (eg. piped from aws_csv_creds.sh)


Additional arguments are assumed to be kubectl options, useful for specifying --namespace


Requires kubectl in \$PATH and configured
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<secret_name> [<kubectl_options>]"

help_usage "$@"

min_args 1 "$@"

#kubectl get secret stackdriver-api-key -o 'jsonpath={.data.stackdriver-api-key}' | base64 -D
kubectl get secret "$@" -o json |
# @base64d works nicely on jq 1.6 but not available on 1.5
#jq -r '.data | to_entries[] | [.key, (.value | @base64d) ] | @tsv''
jq -r '.data | to_entries[] | [.key, .value] | @tsv' |
while read -r key value; do
    # use --decode not -d / -D which varies between Linux and Mac
    printf '%s\t%s\n' "$key" "$(base64 --decode <<< "$value")"
done
