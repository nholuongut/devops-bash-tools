#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
# Cloudera Navigator fails to download some logs but silently fails without an error or outputting anything, not even the headers
# so this script loop retries the adjacent script cloudera_navigator_audit_logs_download.sh and checks for zero byte CSVs audit logs and retries
# until they're all downloaded. In practice, some logs repeatedly get zero bytes so this isn't entirely effective have to cut your losses on the
# logs that refused to extract from Navigator. Ironically older logs output the headers but not logs, at least indicating that there are no logs
# rather than just giving blank output which is almost certainly another Cloudera bug
#
# Tested on Cloudera Enterprise 5.10

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

sleep_secs=60

if is_mac; then
    stat_bytes="stat -f %z"
else
    stat_bytes="stat -c %s"
fi

time while true; do
    time "$srcdir/cloudera_navigator_audit_logs_download.sh" -k
    # want splitting of args
    # shellcheck disable=SC2086
    # grep -c stops the pipe terminating early causing:
    # find: `stat' terminated by signal 13
    num_zero_files="$(find . -maxdepth 1 -name 'navigator_audit_*.csv' -exec $stat_bytes {} \; | grep -c '^0$')"
    if [ "$num_zero_files" != 0 ]; then
        echo "$num_zero_files files detected that have silently errored resulting in zero byte files, sleeping for $sleep_secs before retrying downloads..."
        sleep $sleep_secs
        continue
    fi
    echo FINISHED
    break
done
