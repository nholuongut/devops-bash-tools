#!/u)sr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
List all service account credential keys that are expired in the current GCP project

Excludes built-in system managed keys which are hidden in the Console UI anyway and are not actionable
or in scope for a key policy audit, and don't expire


Output Format:

<key_id>  <expiry_date>  <service_account_email>


Requires GCloud SDK to be installed and configured for your project


See Also:

    gcp_service_account_credential_keys.py

in the DevOps Python tools repo:

    https://github.com/nholuongutnho/DevOps-Python-tools/
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

service_accounts="$(gcloud iam service-accounts list --format='get(email)')"

now="$(date '+%s')"

for service_account in $service_accounts; do
    gcloud iam service-accounts keys list --iam-account "$service_account" \
                                          --format='table[no-heading](name.basename(), validBeforeTime)' \
                                          --filter='keyType != SYSTEM_MANAGED' |
    while read -r id expiry_date; do
        expiry_epoch="$(date --date "$expiry_date" '+%s')"
        if [ "$expiry_epoch" -le "$now" ]; then
            printf '%s  %s\n' "$id" "$expiry_date"
        fi
    done |
    # suffixing is better for alignment as service account email lengths are the only variable field and otherwise
    # this comes out all misaligned or we have to pipe through column -t with no progress output,
    # leaving appearance of a long O(n) hang before results
    #sed "s/^/$service_account    /"
    sed "s/$/  $service_account/"
done
