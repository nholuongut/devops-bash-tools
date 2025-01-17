#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

# intentionally not using lib/ so that this script is standalone and can be easily distributed to VMs without git cloning the whole repo
usage(){
    echo "
AWS EC2 Metadata API query shortcut

${0##*/} <resource> [curl_options]

eg. ${0##*/} public-ipv4
    ${0##*/} public-hostname
    ${0##*/} local-ipv4
    ${0##*/} local-hostname
    ${0##*/} ami-id
    ${0##*/} instance-type
    ${0##*/} placement/availability-zone

See also ec2-metadata script which is a more complete shell script
"
    exit 3
}

if [ $# -lt 1 ] ||
   [[ "${1:-}" =~ -.* ]]; then
    usage
fi

if ! curl -sS --connect-timeout 2 http://169.254.169.254/ &>/dev/null; then
    echo
    echo "This script must be run from within an EC2 instance as that is the only place the AWS EC2 Metadata API is available"
    exit 2
fi

curl "http://169.254.169.254/latest/meta-data/${1:-}" "${@:2}"
