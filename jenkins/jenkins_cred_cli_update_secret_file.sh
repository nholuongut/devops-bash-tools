#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: nholuongut-test-cli-secret-file ~/.aws/keys/circleci_accessKeys.csv "" "" "My Updated Secret File"

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Updates a Jenkins Secret File Credential in the given credential store and domain

Defaults to the 'system::system::jenkins' provider store and global domain '_'

If credential id and secret file aren't given as arguments, then reads from stdin, reading in KEY=VALUE
or standard shell export format - useful for shell piping

In cases where you are reading secrets from stdin, you can set the store and domain via the environment variables
\$JENKINS_SECRET_STORE and \$JENKINS_SECRET_DOMAIN

Tested on Jenkins 2.319 with Credentials plugin 2.5

Uses the adjacent jenkins_cli.sh - see there for authentication details


Examples:

    # update a credential with id 'aws-access-key-csv', and file ~/.aws/keys/jenkins_accessKeys.csv:

        ${0##*/} aws-access-key-csv ~/.aws/keys/jenkins_accessKeys.csv

    # with a description, leaving the store and domain as the default global one:

        ${0##*/} aws-access-key-csv ~/.aws/keys/jenkins_accessKeys.csv '' '' 'My AWS Access Key CSV'

    # or piped from standard input:

        # export JENKINS_SECRET_STORE and JENKINS_SECRET_DOMAIN if using stdin but not using system global store

        echo aws-access-key-csv=~/.aws/keys/jenkins_accessKeys.csv | ${0##*/}
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<credential_id> <secret_file> <store> <domain> <description>]"

help_usage "$@"

id="${1:-}"
secret_file="${2:-}"
store="${3:-${JENKINS_SECRET_STORE:-system::system::jenkins}}"
domain="${4:-${JENKINS_SECRET_DOMAIN:-_}}"
description="${5:-}"

update_credential(){
    local key_value="$1"
    local description="${2:-}"
    parse_export_key_value "$key_value"
    # key/value are exported by above function
    # shellcheck disable=SC2154
    local id="$key"
    # shellcheck disable=SC2154
    local secret="$value"
    if ! [ -f "$secret" ]; then
        die "secret file '$secret' not found!"
    fi
    timestamp "Reading secret file '$secret'"
    secret="$(cat "$secret")"
    local domain_name="$domain"
    if [ "$domain_name" = '_' ]; then
        domain_name='GLOBAL'
    fi
    local xml="<org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl>
  <scope>$domain</scope>
  <id>$id</id>
  <description>$description</description>
  <secret>$secret</secret>
</org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl>"
    timestamp "Updating Jenkins secret file credential '$id' in store '$store' domain '$domain_name'"
    "$srcdir/jenkins_cli.sh" update-credentials-by-xml "$store" "$domain" "$id" <<< "$xml"
    timestamp "Secret '$id' updated"
}

if [ -n "$secret_file" ]; then
    update_credential "$id"="$secret_file" "$description"
else
    while read -r id_secretFile description; do
        update_credential "$id_secretFile" "$description"
    done < <(sed 's/^[[:space:]]*export[[:space:]]*//; /^[[:space:]]*$/d')
fi
