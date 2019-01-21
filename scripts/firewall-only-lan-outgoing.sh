#!/bin/sh

# Allow access to the LAN
ufw allow out to 192.168.2.0/24

# Deny anything else outgoing
ufw default deny outgoing

