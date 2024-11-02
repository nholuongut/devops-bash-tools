#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

# ============================================================================ #
#                                T e a m C i t y
# ============================================================================ #

# sets TeamCity URL to the local docker and finds and loads the current container's superuser token to the environment for immediate use with teamcity_api.sh
teamcity_local(){
    TEAMCITY_SUPERUSER_TOKEN="$(
        # project name must match COMPOSE_PROJECT_NAME from teamcit.sh otherwise will fail to find token
        docker-compose -p bash-tools -f "$(dirname "${BASH_SOURCE[0]}")/../docker-compose/teamcity.yml" \
            logs teamcity-server | \
        grep -E -o 'Super user authentication token: [[:alnum:]]+' | \
        tail -n1 | \
        awk '{print $5}' || :
    )"

    export TEAMCITY_SUPERUSER_TOKEN
    export TEAMCITY_URL="http://localhost:8111"
}
