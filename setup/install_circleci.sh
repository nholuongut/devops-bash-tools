#!/usr/bin/env bash


# Installs Circle CI using Homebrew on Mac or direct download to ~/bin otherwise

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/../lib/utils.sh"

section "Installing Circle CI"

if type -P circleci &>/dev/null; then
    echo "circleci already installed"
    echo
    exit 0
fi

if is_mac; then
    "$srcdir/../packages/brew_install_packages.sh" circleci
else
    curl -fLSs https://circle.ci/cli | DESTDIR=~/bin bash
fi

# unreliable that HOME is set, ensure shell evaluates to the right thing before we use it
[ -n "${HOME:-}" ] || HOME=~

export PATH="$PATH:$HOME/bin"

if ! is_CI && [ -t 1 ]; then
    circleci setup
fi
