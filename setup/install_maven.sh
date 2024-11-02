#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

echo "================================================================================"
echo "                           M a v e n   I n s t a l l"
echo "================================================================================"

MAVEN_VERSION=${1:-${MAVEN_VERSION:-3.3.9}}

BASE=/opt

echo
date '+%F %T  Starting...'
start_time="$(date +%s)"
echo

if ! [ -e "$BASE/maven" ]; then
    mkdir -p "$BASE"
    cd "$BASE"
    wget -t 100 --retry-connrefused "https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz"
    tar zxvf "apache-maven-$MAVEN_VERSION-bin.tar.gz"
    ln -sv -- "apache-maven-$MAVEN_VERSION" maven
    rm -f -- "apache-maven-$MAVEN_VERSION-bin.tar.gz"
    echo
    echo "Maven Install done"
else
    echo "$BASE/maven already exists - doing nothing"
fi
if ! [ -e /etc/profile.d/maven.sh ]; then
    echo "Adding /etc/profile.d/maven.sh"
    # shell execution tracing comes out in the file otherwise
    set +x
    cat >> /etc/profile.d/maven.sh <<EOF
export MAVEN_HOME=/opt/maven
export PATH=\$PATH:\$MAVEN_HOME/bin
EOF
fi

echo
date '+%F %T  Finished'
echo
end_time="$(date +%s)"
time_taken="$((end_time - start_time))"
echo "Completed in $time_taken secs"
echo
echo "=================================================="
echo "            Maven Install Completed"
echo "=================================================="
echo
