#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

# Install OpenSSH - callable via curl to bash from builds
#
# Written for use in AppVeyor to install OpenSSH if not installed already to work around issues:
#
# https://github.com/appveyor/ci/issues/3373
#
# https://github.com/appveyor/ci/issues/3384
#
# has since been added to AppVeyor's own scripts:
#
# https://github.com/appveyor/ci/pull/3385

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

sudo=""
[ $EUID -eq 0 ] || sudo=sudo

if ! command -v sshd &>/dev/null; then
    if command -v apt-get &>/dev/null; then
        $sudo apt-get update
        $sudo apt-get install -y openssh-server
    elif command -v yum &>/dev/null; then
        $sudo yum install -y openssh-server
    elif command -v apk &>/dev/null; then
        $sudo apk update
        $sudo apk add openssh-server
    fi
fi
