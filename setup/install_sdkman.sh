#!/usr/bin/env bash
#


# Installs SDKMan

# https://sdkman.io/install

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

curl -sS "https://get.sdkman.io" | bash
