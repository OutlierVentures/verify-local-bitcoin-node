#!/bin/bash

source config

echo "Allowing outgoing traffic beyond the LAN..."
sudo ./firewall-full-outgoing.sh

echo "Starting bitcoind..."

bitcoind -daemon --datadir="${BITCOIND_PATH}"
