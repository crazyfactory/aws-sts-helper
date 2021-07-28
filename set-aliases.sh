#!/bin/bash
set -eE

AR_PATH=$(realpath assume-role.sh)
GST_PATH=$(realpath get-session-token.sh)

sed -i '/^alias assume-role/d' ~/.bashrc || true
sed -i '/^alias get-session-token/d' ~/.bashrc || true

echo alias assume-role=\'${AR_PATH}\' >> ~/.bashrc
echo alias get-session-token=\'${GST_PATH}\' >> ~/.bashrc
