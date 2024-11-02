#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


# Installs PowerShell on Ubuntu
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

if ! grep -q '^DISTRIB_ID=Ubuntu' /etc/*release; then
    echo "Not Ubuntu"
    exit 1
fi

# Ubuntu 16.04 and 18.04 - 18.10 onwards use Snap, will require updates
# 16.04 works, 18.04 has broken package dependency
if grep -E '^DISTRIB_RELEASE=(19|18\.10)' /etc/*release; then
    # assigned in lib
    # shellcheck disable=SC2154
    $sudo snap install powershell --classic
else
    version="$(awk -F= '/^DISTRIB_RELEASE=/{print $2}' /etc/*release)"
    $sudo apt-get update
    $sudo apt-get install -y wget apt-transport-https
    wget -q "https://packages.microsoft.com/config/ubuntu/$version/packages-microsoft-prod.deb"
    $sudo dpkg -i packages-microsoft-prod.deb
    $sudo apt-get update
    $sudo apt-get install -y powershell
fi
