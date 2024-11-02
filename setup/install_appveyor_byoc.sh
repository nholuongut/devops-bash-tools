#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


# Installs PowerShell on Mac and various Linux distros
#
# https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux

# Mac - could do this, but following standard powershell install and calling from there works too
#
# https://www.appveyor.com/docs/byoc/mac/
#
# HOMEBREW_HOST_AUTH_TKN=<host-authorization-token> HOMEBREW_APPVEYOR_URL=https://ci.appveyor.com brew install appveyor/brew/appveyor-host-agent
#
# shows up in brew services either way:
#
# brew services list

# Linux:
#
# https://www.appveyor.com/docs/byoc/linux/

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! type -P pwsh &>/dev/null; then
    "$srcdir/install_powershell.sh"
fi

# AppVeyor host dependencies
# sysvinit-tools on RHEL, but appveyor byoc looks for dpkg so is probably only compatible with debian based distributions
if grep -Eiq 'debian|ubuntu' /etc/*release; then
    apt-get update
    apt-get install -y libcap2-bin libterm-ui-perl sudo sysvinit-utils
fi

# leading whitespace break PowerShell commands
pwsh << EOF
Install-Module AppVeyorBYOC -Scope CurrentUser -Force; Import-Module AppVeyorBYOC
EOF
