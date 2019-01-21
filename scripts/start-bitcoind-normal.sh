#!/bin/bash

source read-config.sh
if [[ $? != 0 ]]; then exit; fi

echo "Allowing outgoing traffic beyond the LAN..."
sudo ./firewall-full-outgoing.sh

echo "Starting bitcoind..."

bitcoind -daemon --datadir="${BITCOIND_PATH}"
