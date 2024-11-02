#!/bin/sh
#


# Installs Ruby RVM

set -eu
[ -n "${DEBUG:-}" ] && set -x

if type apk >/dev/null 2>&1; then
    apk --no-cache add bash curl procps
elif type apt-get >/dev/null 2>&1; then
    apt-get update
    apt-get install -y curl procps
elif type yum >/dev/null 2>&1; then
    echo "rhel based systems aleady have curl"
fi

exec bash <<EOF

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

curl -sSL https://get.rvm.io | bash -s stable --rails

EOF
