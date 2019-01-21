#!/bin/bash

source config

bitcoin-cli --datadir="${BITCOIND_PATH}" $1 $2 $3 $4 $5
