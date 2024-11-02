#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

# ============================================================================ #
#                                C i r c l e C I
# ============================================================================ #

bash_tools="${bash_tools:-$(dirname "${BASH_SOURCE[0]}")/..}"

if ! type github_owner_repo &>/dev/null; then
    # shellcheck disable=SC1090,SC1091
    . "$bash_tools/.bash.d/git.sh"
fi

circleci_debug(){
    circleci_project_set_env_vars.sh github/$(github_owner_repo) DEBUG=1
}

circleci_undebug(){
    circleci_project_delete_env_vars.sh github/$(github_owner_repo) DEBUG
}
