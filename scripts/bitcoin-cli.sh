#!/bin/bash

source read-config.sh
if [[ $? != 0 ]]; then exit; fi

bitcoin-cli --datadir="${BITCOIND_PATH}" $1 $2 $3 $4 $5
