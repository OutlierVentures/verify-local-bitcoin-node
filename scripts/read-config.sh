#!/bin/bash

if [ ! -e config ]; then
	echo "No config file found. Please create it. Use config.example as a start."
        exit 1
fi

source config

