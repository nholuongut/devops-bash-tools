#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

BAZEL_VERSION="${1:-3.2.0}"

export PATH="$PATH:$HOME/bin"

if type -P bazel &>/dev/null; then
    if bazel version | grep -q "^Build label: $BAZEL_VERSION$"; then
        echo "Bazel is already installed and the right version: $BAZEL_VERSION"
        exit 0
    fi
fi

platform="$(uname -s | tr '[:upper:]' '[:lower:]')"

cd /tmp

curl -fLO "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-$platform-x86_64.sh"

chmod +x "bazel-${BAZEL_VERSION}-installer-$platform-x86_64.sh"
./"bazel-${BAZEL_VERSION}-installer-$platform-x86_64.sh" --user  # --user installs to ~/bin and sets the .bazelrc path to ~/.bazelrc

bazel version
