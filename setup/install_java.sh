#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
#. "$srcdir/bash-tools/lib/utils.sh"

export PATH="$srcdir:$srcdir/..:$PATH"

if type -P yum &>/dev/null; then
    # RHEL / CentOS does the right thing and pulls in the current version
    #java
    #java-headless
    install_packages.sh java-headless  # won't install to $PATH, make sure to add /usr/lib/jvm/jre/bin/ to $PATH (jre is a symlink)
elif type -P apt-get &>/dev/null; then
    # Debian / Ubuntu
    #openjdk-8-jre-headless  # smaller than openjdk-11 package (127 vs 200 MB) and more tested
    #openjdk-11-jre-headless
    install_packages.sh openjdk-11-jre-headless
elif type -P apk &>/dev/null; then
    # Alpine
    #openjdk8-jre
    #openjdk9-jre-headless
    #openjdk10-jre-headless
    #openjdk11-jre-headless
    install_packages.sh openjdk8-jre
fi
