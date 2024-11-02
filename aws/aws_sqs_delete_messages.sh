#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/aws.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Deletes 1-10 AWS SQS messages from a given SQS queue URL

Defaults to 1 message, max 10 messages


Queue URL argument can be copied from SQS queue page and should look similar to:

    https://sqs.<region>.amazonaws.com/<account_number>/myname.fifo

    eg.

    https://sqs.\$AWS_DEFAULT_REGION.amazonaws.com/\$AWS_ACCOUNT_ID/myname.fifo


$usage_aws_cli_required
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<queue_url> [<num_messages>]"

help_usage "$@"

min_args 1 "$@"

queue_url="$1"
num_messages="${2:-1}"

aws sqs receive-message --queue-url "$queue_url" --max-number-of-messages="$num_messages" |
jq -r '.Messages[] | .ReceiptHandle' |
while read -r receipt_handle; do
    timestamp "deleting message"
    aws sqs delete-message --queue-url "$queue_url" --receipt-handle "$receipt_handle"
done
