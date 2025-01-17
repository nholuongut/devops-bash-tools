#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

# ============================================================================ #
#                                  C u s t o m
# ============================================================================ #

# Stuff that's overly custom and only sourced for my own user
#
# eg. $USER specific env vars and too short less generic aliases

if ! [[ $USER =~ nholuongut|nho ]]; then
    return 0
fi

# put secret tokens in vars() or ~/.bashrc.local instead
export GITHUB_USER=nholuongutnho
export TRAVIS_USER="nholuongutnho"
export BUILDKITE_ORGANIZATION=nholuongut-nho
export SEMAPHORE_CI_ORGANIZATION=nholuongutnho

alias tll="travis_last_log.py"

alias goto=go-tools
alias pyt=pytools
alias to=perl-tools

# shellcheck disable=SC2154
export plugins="$github/nagios-plugins"
export pl="$plugins"
alias plugins='sti pl; cd $pl'
alias pl=plugins

# travis_last_log.py should be in $PATH from DevOps-Python-tools repo
alias pll="travis_last_log.py nholuongutnho/nagios-plugins"
export pl2="${plugins}2"
alias pl2='sti pl2; cd $pl2'

alias pytl="tll /pytools"
alias pyt2="pytools2"
alias pyl="pylib"
alias pyll="tll /pylib"

alias tol="tll /tools"
alias to2="tool2"

# clashes with the D2 diagramming language
#alias d2="Dockerfiles2"
alias Dockerfilesl="tll /Dockerfiles"
