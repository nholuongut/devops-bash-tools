#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
# 
# Installs PowerShell on Debian
#
# https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

sudo=""
[ $EUID -eq 0 ] || sudo=sudo

if type -P pwsh &>/dev/null; then
    echo "PowerShell is already installed"
    exit 0
fi

# works on Debian 8 & 9
# Debian 10 not supported yet, only in Preview
# https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7#debian-10
if ! grep -q '^ID=debian' /etc/*release; then
    echo "Not Debian"
    exit 1
fi

# works in Stretch but not in Jessie
#codename="$(awk -F= '/^VERSION_CODENAME=/{print $2}' /etc/*release)"
codename="$(grep -Eo '^VERSION="[[:digit:]]* \(.+\)"' /etc/*release | sed 's/.*(//; s/)//; s/"//g')"
$sudo apt-get update
$sudo apt-get install -y curl gnupg apt-transport-https
curl https://packages.microsoft.com/keys/microsoft.asc | $sudo apt-key add -
$sudo sh -c "echo 'deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-$codename-prod $codename main' > /etc/apt/sources.list.d/microsoft.list"
$sudo apt-get update
$sudo apt-get install -y powershell
