#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Nho Luong
#  Date: 2020-12-04 23:05:31 +0000 (Fri, 04 Dec 2020)

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090
. "$srcdir/../lib/git.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Tests the git_to_azure_url function from lib/git.sh
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

src[0]='git@devops.azure.com:/nholuongut/pylib'
dest[0]='git@devops.azure.com:v3/nholuongut/GitHub/pylib'

src[1]='git@devops.azure.com:/nholuongut/nagios-plugin-kafka'
dest[1]='git@devops.azure.com:v3/nholuongut/GitHub/nagios-plugin-kafka'

src[2]='git@devops.azure.com:nholuongut/DevOps-Bash-tools'
dest[2]='git@devops.azure.com:v3/nholuongut/GitHub/DevOps-Bash-tools'

src[3]='git@devops.azure.com:nholuongut/DevOps-Golang-tools'
dest[3]='git@devops.azure.com:v3/nholuongut/GitHub/DevOps-Golang-tools'

src[4]='git@devops.azure.com:nholuongut/Dockerfiles.git'
dest[4]='git@devops.azure.com:v3/nholuongut/GitHub/Dockerfiles'

src[5]='git@devops.azure.com:nholuongut/HAProxy-configs'
dest[5]='git@devops.azure.com:v3/nholuongut/GitHub/HAProxy-configs'

src[6]='git@devops.azure.com:nholuongut/Nagios-Plugins'
dest[6]='git@devops.azure.com:v3/nholuongut/GitHub/Nagios-Plugins'

src[7]='git@devops.azure.com:nholuongut/SQL-scripts'
dest[7]='git@devops.azure.com:v3/nholuongut/GitHub/SQL-scripts'

src[8]='git@devops.azure.com:nholuongut/Spotify-Playlists.git'
dest[8]='git@devops.azure.com:v3/nholuongut/GitHub/Spotify-Playlists'

src[9]='git@devops.azure.com:nholuongut/Templates'
dest[9]='git@devops.azure.com:v3/nholuongut/GitHub/Templates'

src[10]='git@devops.azure.com:nholuongut/kubernetes-templates'
dest[10]='git@devops.azure.com:v3/nholuongut/GitHub/kubernetes-templates'

src[11]='git@devops.azure.com:nholuongut/spotify-tools.git'
dest[11]='git@devops.azure.com:v3/nholuongut/GitHub/spotify-tools'

src[12]='git@devops.azure.com:nholuongut/sql-keywords'
dest[12]='git@devops.azure.com:v3/nholuongut/GitHub/sql-keywords'

src[13]='git@devops.azure.com:/nholuongut/Nagios-Plugin-Kafka'
dest[13]='git@devops.azure.com:v3/nholuongut/GitHub/Nagios-Plugin-Kafka'

src[14]='git@devops.azure.com:/nholuongut/pylib'
dest[14]='git@devops.azure.com:v3/nholuongut/GitHub/pylib'

src[15]='git@devops.azure.com:nholuongut/DevOps-Bash-tools'
dest[15]='git@devops.azure.com:v3/nholuongut/GitHub/DevOps-Bash-tools'

src[16]='git@devops.azure.com:nholuongut/DevOps-Golang-tools'
dest[16]='git@devops.azure.com:v3/nholuongut/GitHub/DevOps-Golang-tools'

src[17]='git@devops.azure.com:nholuongut/Dockerfiles.git'
dest[17]='git@devops.azure.com:v3/nholuongut/GitHub/Dockerfiles'

src[18]='git@devops.azure.com:nholuongut/HAProxy-configs'
dest[18]='git@devops.azure.com:v3/nholuongut/GitHub/HAProxy-configs'

src[19]='git@devops.azure.com:nholuongut/Nagios-Plugins'
dest[19]='git@devops.azure.com:v3/nholuongut/GitHub/Nagios-Plugins'

src[20]='git@devops.azure.com:nholuongut/SQL-scripts'
dest[20]='git@devops.azure.com:v3/nholuongut/GitHub/SQL-scripts'

src[21]='git@devops.azure.com:nholuongut/Spotify-Playlists.git'
dest[21]='git@devops.azure.com:v3/nholuongut/GitHub/Spotify-Playlists'

src[22]='git@devops.azure.com:nholuongut/Spotify-tools.git'
dest[22]='git@devops.azure.com:v3/nholuongut/GitHub/Spotify-tools'

src[23]='git@devops.azure.com:nholuongut/Templates'
dest[23]='git@devops.azure.com:v3/nholuongut/GitHub/Templates'

src[24]='git@devops.azure.com:nholuongut/kubernetes-templates'
dest[24]='git@devops.azure.com:v3/nholuongut/GitHub/kubernetes-templates'

src[25]='git@devops.azure.com:nholuongut/sql-keywords'
dest[25]='git@devops.azure.com:v3/nholuongut/GitHub/sql-keywords'

src[26]='git@devops.azure.com:nholuongut/Spotify-Playlists.git'
dest[26]='git@devops.azure.com:v3/nholuongut/GitHub/Spotify-Playlists'

src[27]='ssh://git@devops.azure.com/nholuongut/DevOps-Perl-tools'
dest[27]='ssh://git@devops.azure.com/v3/nholuongut/GitHub/DevOps-Perl-tools'

src[28]='ssh://git@devops.azure.com/nholuongut/lib-java'
dest[28]='ssh://git@devops.azure.com/v3/nholuongut/GitHub/lib-java'

src[29]='ssh://git@devops.azure.com/nholuongut/lib'
dest[29]='ssh://git@devops.azure.com/v3/nholuongut/GitHub/lib'

src[30]='ssh://git@devops.azure.com:/nholuongut/DevOps-Python-tools'
dest[30]='ssh://git@devops.azure.com:/v3/nholuongut/GitHub/DevOps-Python-tools'

src[31]='ssh://git@devops.azure.com/nholuongut/lib-java'
dest[31]='ssh://git@devops.azure.com/v3/nholuongut/GitHub/lib-java'

src[32]='ssh://git@devops.azure.com:/nholuongut/DevOps-Python-tools'
dest[32]='ssh://git@devops.azure.com:/v3/nholuongut/GitHub/DevOps-Python-tools'

src[33]='ssh://git@ssh.devops.azure.com/nholuongut/DevOps-Perl-tools'
dest[33]='ssh://git@ssh.devops.azure.com/v3/nholuongut/GitHub/DevOps-Perl-tools'

src[34]='ssh://git@ssh.devops.azure.com/nholuongut/lib'
dest[34]='ssh://git@ssh.devops.azure.com/v3/nholuongut/GitHub/lib'

# expands to the list of indicies in the array, starting at zero - this is easier to work with that ${#src} which is a total
# that is off by one for index usage and doesn't support sparse arrays for any  missing/disabled test indicies
test_numbers="${!src[*]}"

for i in $test_numbers; do
    [ -n "${src[$i]:-}" ]  || { echo "code error: src[$i] not defined";  exit 1; }
    [ -n "${dest[$i]:-}" ] || { echo "code error: dest[$i] not defined"; exit 1; }
    echo "git_to_azure_url ${src[$i]}"
    converted_repo_url="$(git_to_azure_url "${src[$i]}")"
    if [ "$converted_repo_url" != "${dest[$i]}" ]; then
        echo "ERROR: unit test failed"
        echo
        echo "Expected: ${dest[$i]}"
        echo "Got:      $converted_repo_url"
        exit 2
    fi
    #echo "checking URL result '$converted_repo_url' is valid"
    #if ! git ls-remote "$converted_repo_url"; then
    #    echo "ERROR: unit test failed - URL failed git ls-remote test"
    #    exit 3
    #fi
    echo
done

echo
echo "SUCCESS: git_to_azure_url URL conversion tests passed"
