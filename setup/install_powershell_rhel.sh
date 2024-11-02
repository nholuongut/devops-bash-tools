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

if ! grep -qi 'redhat' /etc/*release; then
    echo "Not RHEL / CentOS"
    exit 1
fi

version="$(awk -F= '/^VERSION_ID=/{print $2}' /etc/*release)"
version="${version//\"/}"

if [ "$version" != 7 ]; then
    echo "Unsupported RHEL/CentOS version"
    exit 1
fi

curl "https://packages.microsoft.com/config/rhel/$version/prod.repo" | $sudo tee /etc/yum.repos.d/microsoft.repo

$sudo yum install -y powershell
