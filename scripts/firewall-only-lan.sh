#!/bin/bash

source read-config.sh
if [[ $? != 0 ]]; then exit; fi

# Allow access to the LAN
ufw allow out to ${LAN_SUBNET}
ufw allow in from ${LAN_SUBNET}

# Deny anything else outgoing and incoming
ufw default deny outgoing
ufw default deny incoming

echo
echo "ufw firewall config now looks like this:"
echo
ufw status verbose
