#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

if [ "${NO_FAIL:-}" ]; then
    set +eo pipefail
fi

if grep -qi "NAME=Fedora" /etc/*release; then
    echo "Detected Fedora, skipping rpmforge install..."
    exit 0
fi

if rpm -q rpmforge-release; then
    echo "rpmforge-release rpm is already installed, skipping..."
    #exit 0
fi

if yum repolist | grep -qi '\<rpmforge\>'; then
    echo "rpmforge yum repo already detected in yum repolist, skipping..."
    #exit 0
fi

[ $EUID -eq 0 ] && sudo="" || sudo=""

rpm -qi wget || yum install -y wget

major_release="$(grep -ho '[[:digit:]]' /etc/*release | head -n1)"
arch="$(uname -m)"

rpm_url="$(
    curl -sS http://repoforge.org/use/ |
    grep -Eo "http://repository.it4i.cz/mirrors/repoforge/redhat/el$major_release/en/$arch/.*\\.$arch\\.rpm"
)"

wget -t 5 --retry-connrefused -O /tmp/repoforge.rpm "$rpm_url"
$sudo rpm -ivh /tmp/repoforge.rpm
rm -f -- /tmp/repoforge.rpm
