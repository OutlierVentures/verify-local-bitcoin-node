#!/bin/sh

# Allow any outgoing traffic
ufw default allow outgoing

echo
echo "ufw firewall config now looks like this:"
echo
ufw status verbose

