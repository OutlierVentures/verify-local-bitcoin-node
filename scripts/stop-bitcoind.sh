#!/bin/bash

source read-config.sh
if [[ $? != 0 ]]; then exit; fi

bitcoin-cli --datadir="${BITCOIND_PATH}" stop
