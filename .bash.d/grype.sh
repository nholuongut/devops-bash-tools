#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

# ============================================================================ #
#                                   G r y p e
# ============================================================================ #

#set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

#eval "$(grype completion bash)"

# generates auto-completion file to avoid repeating running auto-completion command, and sources from there
#autocomplete grype
