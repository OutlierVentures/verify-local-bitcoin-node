#!/bin/bash

source config

tail -n 100 -f "${BITCOIND_PATH}/debug.log"
