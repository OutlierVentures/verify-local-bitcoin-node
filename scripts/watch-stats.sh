#!/bin/bash

export INTERVAL=10

echo "Starting watch for stats every ${INTERVAL} seconds..."

watch -n ${INTERVAL} "date;echo;./stats.sh"
