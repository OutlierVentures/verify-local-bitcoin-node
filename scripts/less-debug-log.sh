#!/bin/bash

source read-config.sh
if [[ $? != 0 ]]; then exit; fi

less "${BITCOIND_PATH}/debug.log"
