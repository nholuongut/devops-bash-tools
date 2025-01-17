#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: nholuongut-test-api-cert ~/Downloads/test.p12 "" "" "" "My Updated Cert Keystore"


# https://github.com/jenkinsci/credentials-plugin/blob/master/docs/user.adoc#creating-a-credentials

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Updates a Jenkins Certificate Credential in the given credential store and domain

Defaults to the 'system' provider's store and global domain '_'

If credential id and PKCS#12 keystore file aren't given as arguments, then reads from stdin, reading in
'ID=/path/to/keystore Description' or standard shell export format - useful for shell piping

In cases where you are reading secrets from stdin, you can set the store and domain via the environment variables
\$JENKINS_SECRET_STORE and \$JENKINS_SECRET_DOMAIN

Tested on Jenkins 2.319 with Credentials plugin 2.5

Uses the adjacent jenkins_api.sh - see there for authentication details


Examples:

    # If you want to update a sample p12 file, you can do it like this:

        openssl req -x509 -nodes -newkey rsa:2048 -keyout test.key -out test.crt -subj '/CN=test.com'
        openssl pkcs12 -export -inkey test.key -in test.crt -passout pass: -out test.p12

    # update a credential with id 'aws-access-key-csv', and file ~/.aws/keys/jenkins_accessKeys.csv:

        ${0##*/} my-certificate-keystore ~/Downloads/test.p12

    # with a description, leaving the store and domain as the default global one:

        ${0##*/} my-certificate-keystore ~/Downloads/test.p12 '' '' 'My Certificate Keystore'

    # or piped from standard input:

        # export KEYSTORE_PASSWORD, JENKINS_SECRET_STORE and JENKINS_SECRET_DOMAIN if using stdin but not using system global store

        echo my-certificate-keystore=~/Downloads/test.p12 | ${0##*/}
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<credential_id> <keystore> <keystore_password> <store> <domain> <description> <curl_options>]"

help_usage "$@"

id="${1:-}"
keystore="${2:-}"
keystore_password="${3:-${KEYSTORE_PASSWORD:-}}"
store="${4:-${JENKINS_SECRET_STORE:-system}}"
domain="${5:-${JENKINS_SECRET_DOMAIN:-_}}"
description="${6:-}"
for _ in {1..6}; do shift || : ; done
curl_args=("$@")

update_credential(){
    local key_value="$1"
    local description="${2:-}"
    parse_export_key_value "$key_value"
    # key/value are exported by above function
    # shellcheck disable=SC2154
    local id="$key"
    # shellcheck disable=SC2154
    local keystore="$value"
    if ! [ -f "$keystore" ]; then
        die "keystore file '$keystore' not found!"
    fi
    timestamp "Reading keystore file '$keystore'"
    local keystore_contents
    keystore_contents="$(base64 "$keystore")"
    local domain_name="$domain"
    if [ "$domain_name" = '_' ]; then
        domain_name='GLOBAL'
    fi
    local xml="<com.cloudbees.plugins.credentials.impl.CertificateCredentialsImpl>
  <scope>$domain</scope>
  <id>$id</id>
  <description>$description</description>
  <keyStoreSource class=\"com.cloudbees.plugins.credentials.impl.CertificateCredentialsImpl\$UploadedKeyStoreSource\">
    <uploadedKeystoreBytes>$keystore_contents</uploadedKeystoreBytes>
  </keyStoreSource>
  <password>$keystore_password</password>
</com.cloudbees.plugins.credentials.impl.CertificateCredentialsImpl>"
    timestamp "Updating Jenkins certificate keystore credential '$id' in store '$store' domain '$domain_name'"
    "$srcdir/jenkins_api.sh" "/credentials/store/$store/domain/$domain/credential/$id/config.xml" -X POST -H "Content-Type: application/xml" -d @<(cat <<< "$xml") ${curl_args:+"${curl_args[@]}"}
    timestamp "Secret '$id' updated"
}

if [ -n "$keystore" ]; then
    update_credential "$id"="$keystore" "$description"
else
    while read -r id_keystore description; do
        update_credential "$id_keystore" "$description"
    done < <(sed 's/^[[:space:]]*export[[:space:]]*//; /^[[:space:]]*$/d')
fi
