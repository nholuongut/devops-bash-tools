#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Dumps a trace of the bash profile, .bashrc and all related shell startup costs to a given file

Useful to find out why spawning new bash shells gets slow

I've used this to cut down from 20 seconds to 2 seconds

Tips:

- bash completion is expensive and to be mostly avoided
- avoid iterating on directories with lots of files, use a targeted find command to efficiently pre-filter - this also reduces the amount of shell tracing
    eg. for x in somedir_full_of_files/*; do [ -d '\$x' ] || continue; ... ; done   <-- this is expensive and noisy in traces
- running headtail.py -n 5 on the trace file can be useful, although additional timings added to this file reduce the need
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<filename>"

help_usage "$@"

num_args 1 "$@"

trace_file="$1"

timestamp "Running bash interactive with shell tracing - output results to '$trace_file'"
# the 'time' command outputs a separating space line already
#echo >&2
time bash -ix -c 'echo' 2>&1 | logger -s 2>"$trace_file"
echo >&2
timestamp "Bash profile trace can now be found in the trace file '$trace_file'"
