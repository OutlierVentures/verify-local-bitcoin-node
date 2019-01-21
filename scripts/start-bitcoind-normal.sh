#!/bin/bash

source read-config.sh
if [[ $? != 0 ]]; then exit; fi

echo "Allowing network traffic beyond the LAN..."
sudo ./firewall-allow-all.sh

echo "Starting bitcoind..."

bitcoind -daemon --datadir="${BITCOIND_PATH}"
