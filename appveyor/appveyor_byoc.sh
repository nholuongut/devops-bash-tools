#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et



set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

if [ -z "${APPVEYOR_TOKEN:-}" ]; then
    echo "\$APPVEYOR_TOKEN not found in environment"
    exit 1
fi

export PATH="$PATH:/opt/appveyor/host-agent"

if ! type -P appveyor-host-agent &>/dev/null; then
    "$srcdir/../setup/install_appveyor_byoc.sh"
    clear
fi

# leading whitespace break PowerShell commands
pwsh <<EOF
Import-Module AppVeyorBYOC
Connect-AppVeyorToComputer -AppVeyorUrl https://ci.appveyor.com -ApiToken $APPVEYOR_TOKEN
EOF

if is_inside_docker && [ -x /opt/appveyor/host-agent/appveyor-host-agent ]; then
    cd /opt/appveyor/host-agent
    /opt/appveyor/host-agent/appveyor-host-agent
fi
