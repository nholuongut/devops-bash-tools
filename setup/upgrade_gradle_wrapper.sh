#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

GRADLE_VERSION="${GRADLE_VERSION:-6.4.1}"

./gradlew wrapper --gradle-version="$GRADLE_VERSION" --distribution-type=bin
