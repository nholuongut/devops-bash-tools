#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: eu-west-1 ROUTE53_HEALTHCHECKS


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Returns all the AWS IPs for a given Region and Service using the AWS ip-range json API:

    https://ip-ranges.amazonaws.com/ip-ranges.json

To get and use these IPs directly in Terraform, see the Cloudflare Firewall module in https://github.com/nholuongutnho/Terraform

Examples:

    Lists all regions and their services to filter on:

        ${0##*/} list

    Get all IPs for eu-west-1 region:

        ${0##*/} eu-west-1

    Get all eu-west-1 IPs for EC2, S3 or Route 53 Healthchecks:

        ${0##*/} eu-west-1 EC2
        ${0##*/} eu-west-1 S3
        ${0##*/} eu-west-1 ROUTE53_HEALTHCHECKS

    Get global Route 53 Healthcheck IPs:

        ${0##*/} GLOBAL ROUTE53_HEALTHCHECKS

    Get all Route 53 Healthcheck IPs in all regions:

        ${0##*/} all ROUTE53_HEALTHCHECKS

"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<region> <service> | list]"

help_usage "$@"

url="https://ip-ranges.amazonaws.com/ip-ranges.json"
region="${1:-}"
service="${2:-}"

# All regions are lowercase except for GLOBAL
region="$(tr '[:upper:]' '[:lower:]' <<< "$region")"
if [ "$region" = global ]; then
    region=GLOBAL
fi
# All Services are uppercase
service="$(tr '[:lower:]' '[:upper:]' <<< "$service")"

if [ "$region" = list ]; then
    curl -sS "$url" |
    jq -r '.prefixes[] | [.region, .service] | @tsv' | sort -u
    exit 0
fi

curl -sSf "$url" |
#jq -r ".prefixes[]" |
#if [ -n "$region" ] && [ "$region" != all ]; then
#    #jq -r ".prefixes[] | select(.region == \"$region\") | .ip_prefix"
#    jq -r "select(.region == \"$region\")"
#else
#    cat
#fi |
#if [ -n "$service" ] && [ "$service" != all ]; then
#    jq -r "select(.service == \"$service\")"
#else
#    cat
#fi |
#jq -r '.ip_prefix'
jq -r "
    .prefixes[] |
    if(\"$region\" != \"\" and \"$region\" != \"all\") then
        select(.region == \"$region\")
    else
        .
    end |
    if(\"$service\" != \"\" and \"$service\" != \"all\") then
        select(.service == \"$service\")
    else
        .
    end |
    .ip_prefix
"  # end jq script
