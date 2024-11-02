#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
#srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Personal Language Caches we want to check have been removed:
#
# .cache => Python pip
#
# .cpan  => Perl
# .cpanm
#
# .gem   => Ruby
#
# Java / Scala / Groovy:
#
# .gradle => Gradle
# .groovy => Groovy (contains grapes/)
# .ivy    => Ivy (Sbt / Gradle)
# .ivy2
# .m2     => Maven
# .sbt    => SBT

personal_cache_list="
.cache
.cpan
.cpanm
.gem
.gradle
.groovy
.ivy
.ivy2
.m2
.sbt
"

exitcode=0

for cache in $personal_cache_list; do
    for home in /root ~; do
        # This might fail if we're not running as root :-/
        # consider sudo'ing and find / -type d -name $cache but that might find .cache under some app or something, although we should probably remove that too
        # for now this is good enough as most docker images are built as root
        # should test for sudo availability as well
        if [ -e "$home/$cache" ]; then
            echo "$home/$cache detected"
            exitcode=1
        fi
    done
done

exit $exitcode
