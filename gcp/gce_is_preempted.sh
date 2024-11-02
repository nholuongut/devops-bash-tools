#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

usage(){
    echo "
Checks GCE Metadata API for the preemption status and returns preempted / not preempted and 0 or 1 exit code

Can combine in a shutdown script to do something different if preempted vs a normal shutdown

https://cloud.google.com/compute/docs/instances/create-start-preemptible-instance

https://cloud.google.com/compute/docs/shutdownscript

usage:

${0##*/}
"
    exit 3
}

if [ $# -ne 0 ]; then
    usage
fi

#if ! curl -sS --connect-timeout 2 -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/" &>/dev/null; then
#    echo "This script must be run from within a GCE instance as that is the only place the GCP GCE Metadata API is available"
#    exit 2
#fi

if output="$(curl -sS -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/preempted")"; then
    if grep -q TRUE <<< "$output"; then
        echo "preempted"
        exit 0
    else
        echo "not preempted"
        exit 1
    fi
else
    echo "FAILED to query GCE Metadata API, not running inside GCE?"
    exit 2
fi
