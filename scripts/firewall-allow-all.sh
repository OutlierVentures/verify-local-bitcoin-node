#!/bin/sh

# Allow any outgoing and incoming traffic
ufw default allow outgoing
ufw default allow incoming

echo
echo "ufw firewall config now looks like this:"
echo
ufw status verbose

