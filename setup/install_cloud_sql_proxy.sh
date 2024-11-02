#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

# https://cloud.google.com/sql/docs/postgres/sql-proxy

# Installs Google Cloud SQL Proxy to $HOME/bin
#
# only supports 64-bit Linux / Mac (who uses 32-bit any more?)

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

if type -P cloud_sql_proxy 2>/dev/null; then
    echo "Google Cloud SQL Proxy is already installed, skipping install..."
    exit 0
fi

os="$(uname -s | tr '[:upper:]' '[:lower:]')"

url="https://dl.google.com/cloudsql/cloud_sql_proxy.$os.amd64"

tmpfile="$(mktemp)"

echo "Downloading Google Cloud SQL Proxy"
if type wget &>/dev/null; then
    wget -qO "$tmpfile" "$url"
elif type curl &>/dev/null; then
    curl -sS "$url" > "$tmpfile"
else
    echo "Error: neither wget nor curl were found in your \$PATH, cannot download cloud_sql_proxy"
    exit 1
fi

echo "setting executable"
chmod +x "$tmpfile"

echo "moving to ~/bin"
mv -fv -- "$tmpfile" ~/bin/cloud_sql_proxy

echo "Done. Don't forget to add $HOME/bin to \$PATH"
