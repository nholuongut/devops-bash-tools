#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: nholuongut-test-cli-k8s-sa "My Kubernetes ServiceAccount"


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Creates a Jenkins Kubernetes Service Account Credential in the given credential store and domain

Defaults to the 'system::system::jenkins' provider store and global domain '_'

If credential id is not given as an argument, then reads from stdin, reading in ID=DESCRIPTION format
or standard shell export format - useful for shell piping

In cases where you are reading secrets from stdin, you can set the store and domain via the environment variables
\$JENKINS_SECRET_STORE and \$JENKINS_SECRET_DOMAIN

Tested on Jenkins 2.319 with Credentials plugin 2.5, Kubernetes plugin 1.29.2, and Kubernetes Credential plugin 0.8.0

Uses the adjacent jenkins_cli.sh - see there for authentication details


Examples:

    # create a credential with id 'my-k8s-sa':

        ${0##*/} my-k8s-sa 'My Description'

    # or piped from standard input:

        # export JENKINS_SECRET_STORE and JENKINS_SECRET_DOMAIN if using stdin but not using system global store

        echo my-k8s-sa=my description | ${0##*/}
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<credential_id> <description> <store> <domain>]"

help_usage "$@"

id="${1:-}"
description="${2:-}"
store="${3:-${JENKINS_SECRET_STORE:-system::system::jenkins}}"
domain="${4:-${JENKINS_SECRET_DOMAIN:-_}}"

create_credential(){
    local id="$1"
    local description="${2:-}"
    local domain_name="$domain"
    if [ "$domain_name" = '_' ]; then
        domain_name='GLOBAL'
    fi
    local xml="<org.jenkinsci.plugins.kubernetes.credentials.FileSystemServiceAccountCredential>
  <scope>GLOBAL</scope>
  <id>$id</id>
  <description>$description</description>
</org.jenkinsci.plugins.kubernetes.credentials.FileSystemServiceAccountCredential>"
    timestamp "Creating Jenkins kubernetes service account credential '$id' in store '$store' domain '$domain_name'"
    "$srcdir/jenkins_cli.sh" create-credentials-by-xml "$store" "$domain" <<< "$xml"
    timestamp "Secret '$id' created"
}

if [ -n "$id" ]; then
    create_credential "$id" "$description"
else
    while read -r id description; do
        create_credential "$id" "$description"
    done < <(sed 's/^[[:space:]]*export[[:space:]]*//; /^[[:space:]]*$/d')
fi
