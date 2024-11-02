#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

# Quick script to convert CSV header to column numbers for quicker programming reference
# and reducing human counting errors for large CSVs such as from AWS credential reports
#
# eg.
#
# ./csv_header_indices.sh <<< "user,arn,user_creation_time,password_enabled,password_last_used,password_last_changed,password_next_rotation,mfa_active,access_key_1_active,access_key_1_last_rotated,access_key_1_last_used_date,access_key_1_last_used_region,access_key_1_last_used_service,access_key_2_active,access_key_2_last_rotated,access_key_2_last_used_date,access_key_2_last_used_region,access_key_2_last_used_service,cert_1_active,cert_1_last_rotated,cert_2_active,cert_2_last_rotated"

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

head -n 1 "$@" |
tr ',' '\n' |
nl -v 0  # -v 0 starts indexing at zero as this is what you need when coding
