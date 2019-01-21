#!/bin/bash

source read-config.sh
if [[ $? != 0 ]]; then exit; fi

tail -n 100 -f "${BITCOIND_PATH}/debug.log"
