#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Runs a Drone.io CI Server in Docker

See here to set up the GitHub integration credentials

https://docs.drone.io/server/provider/github/

Need to set \$DRONE_RPC_SECRET to some value for the Runners to authenticate to
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

check_env_defined "DRONE_GITHUB_CLIENT_ID"
check_env_defined "DRONE_GITHUB_CLIENT_SECRET"
check_env_defined "DRONE_RPC_SECRET"

help_usage "$@"

docker run \
  --volume=/var/lib/drone:/data \
  --env=DRONE_GITHUB_CLIENT_ID="$DRONE_GITHUB_CLIENT_ID" \
  --env=DRONE_GITHUB_CLIENT_SECRET="$DRONE_GITHUB_CLIENT_SECRET" \
  --env=DRONE_RPC_SECRET="$DRONE_RPC_SECRET" \
  --env=DRONE_SERVER_HOST="localhost" \
  --env=DRONE_SERVER_PROTO="https" \
  --publish=80:80 \
  --publish=443:443 \
  --restart=always \
  --detach=true \
  --name=drone \
  drone/drone:1
