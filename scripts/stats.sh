#!/bin/bash

source config

export PROCESS_NAME="bitcoind -daemon"

export PID_TO_WATCH=`ps ax | grep "$PROCESS_NAME" | grep -v grep | awk '{print $1}'`

if [ ! "$PID_TO_WATCH" ]; then
	echo "Bitcoind process not found. Did you start it?"
	exit 1
fi

echo "Disk usage:"
du -s "${BITCOIND_PATH}"
echo
echo "Network traffic:"
cat /proc/${PID_TO_WATCH}/net/netstat | grep 'IpExt: ' | awk '{ print $8 "\t" $9 }'
echo
echo "Network connections:"
netstat -an | grep 8333

