#!/usr/bin/env bash
# shellcheck disable=SC2230
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
# during 'curl | bash' ... $BASH_SOURCE isn't set
if [ -n "${BASH_SOURCE[0]:-}" ]; then
    srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

git_url="${GIT_URL:-https://github.com}"

make="${MAKE:-make}"
build="${BUILD:-build}"

git_base_dir=~/github

mkdir -pv "$git_base_dir"

cd "$git_base_dir"

opts="${OPTS:-}"
if [ -z "${NO_TEST:-}" ]; then
    opts="$opts test"
fi

if [ -z "${JAVA_HOME:-}" ]; then
    set +e
    JAVA_HOME="$(which java 2>/dev/null)/.."
    if [ -z "${JAVA_HOME:-}" ]; then
        JAVA_HOME="$(type java 2>/dev/null | sed 's/java is //; s/hashed //; s/[()]//g')"
    fi
    set -e
    if [ -z "${JAVA_HOME:-}" ]; then
        JAVA_HOME="/usr"
    fi
fi

if ! type -P git &>/dev/null ||
   ! type -P make &>/dev/null &&
   [ -n "${srcdir:-}" ]; then
#    if type -P yum &>/dev/null; then
#        yum install -y git make
#    elif type -P apt-get &>/dev/null; then
#        apt-get update
#        apt-get install -y --no-install-recommends git make
#    elif type -P apk &>/dev/null; then
#        apk update
#        apk add git make
#    fi
    "$srcdir/../packages/install_packages.sh" git make
fi

if [ -n "${REPOS:-}" ]; then
    tr '[:space:]' '\n' <<< "$REPOS"
elif [ -n "${srcdir:-}" ]; then
    sed 's/#.*//; s/:/ /; /^[[:space:]]*$/d' < "$srcdir/../setup/repos.txt"
else
    echo "\$REPOS not set and \$srcdir not set/available, possibly due to 'curl ... | bash' usage, cannot determine list of repos to pull and build" >&2
    exit 1
fi |
while read -r repo dir; do
    if [ -z "$dir" ]; then
        dir="$repo"
    fi
    if ! echo "$repo" | grep -q "/"; then
        repo="nholuongutnho/$repo"
    fi
    if ! [ -d "$dir" ]; then
        git clone "$git_url/$repo" "$dir"
    fi
    pushd "$dir"
    git pull --no-edit
    git submodule update --init
    #  shellcheck disable=SC2086
    if [ -z "${NOBUILD:-}" ] &&
       [ -z "${NO_BUILD:-}" ]; then
        "$make" "$build" $opts
    fi
    if [ -f /.dockerenv ]; then
        for x in system-packages-remove clean deep-clean; do
            if grep -q "^$x:" Makefile bash-tools/Makefile.in 2>/dev/null; then
                $make "$x"
            fi
        done
    fi
    popd
done
