#!/bin/bash

source config

bitcoin-cli --datadir="${BITCOIND_PATH}" stop
