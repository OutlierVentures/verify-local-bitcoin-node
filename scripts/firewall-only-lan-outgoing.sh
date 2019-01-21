#!/bin/bash

source read-config.sh
if [[ $? != 0 ]]; then exit; fi

# Allow access to the LAN
ufw allow out to ${LAN_SUBNET}

# Deny anything else outgoing
ufw default deny outgoing

echo
echo "ufw firewall config now looks like this:"
echo
ufw status verbose
