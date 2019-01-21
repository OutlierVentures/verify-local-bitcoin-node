#!/bin/bash

source read-config.sh
if [[ $? != 0 ]]; then exit; fi

echo "Restricting network traffic to LAN..."
sudo ./firewall-only-lan.sh

echo "Starting bitcoind, listening only to target node..."
bitcoind -daemon --datadir=${BITCOIND_PATH} --addnode=${SOURCE_NODE_IP} -noconnect
