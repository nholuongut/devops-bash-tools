#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Uses OpenSSL to get the sha256 hash of a certificate crt file

Useful to generating the hash needed for joining a Kubernetes node to a cluster eg.

kubeadm join \\
    --token <token> \\
    --discovery-token-ca-cert-hash sha256:<hash> \\
    k8smaster:6443

To generate this actual command on a live cluster, run the adjacent kubeadm_join_cmd.sh script (which uses this script)
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<file.crt>"

help_usage "$@"

min_args 1 "$@"

# eg. /etc/kubernetes/pki/ca.crt
crt_file="$1"

if ! [ -f "$crt_file" ]; then
    die "ERROR: file not found: $crt_file"
fi

openssl x509 -pubkey -in "$crt_file" |
openssl rsa -pubin -outform der 2>/dev/null |
openssl dgst -sha256 -hex |
sed 's/^.* //'
