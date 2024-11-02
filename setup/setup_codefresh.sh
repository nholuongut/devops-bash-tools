#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

if ! type -P codefresh &>/dev/null; then
    if [ "$(uname -s)" = Darwin ]; then
        echo "Installing codefresh via HomeBrew"
        brew tap codefresh-io/cli
        brew install codefresh
    else
        echo "Installing codefresh via npm"
        npm install codefresh
    fi
fi

if [ -z "${CODEFRESH_KEY:-}" ]; then
    echo "\$CODEFRESH_KEY is not defined"
    exit 1
fi

# generate API key - https://g.codefresh.io/user/settings
echo "creating codefresh auth context"
codefresh auth create-context --api-key "$CODEFRESH_KEY"
