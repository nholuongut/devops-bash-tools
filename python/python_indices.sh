#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

# Quick script to convert Python lists to indices for quicker programming debugging / referencing
#
# eg. copy it to stdin from the python debug output - used when figuring out log component indicies
#
# ./python_indices.sh <<< "['one', 'two', 'three']"

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

cat "$@" |
python -c '
from __future__ import print_function
import ast
#import json
import sys
stdin = sys.stdin.read()
my_list = ast.literal_eval(stdin)
#my_list = json.loads(stdin)
i = 0
for item in my_list:
    print(i, item)
    i += 1
'
