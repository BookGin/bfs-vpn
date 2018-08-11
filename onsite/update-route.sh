#!/usr/bin/env bash

# remove wired default gateway
ip r del default via 10.3.0.1 dev enp1s0 proto dhcp metric 100

# add wired subnet routing explicitly
ip r add 10.13.37.0/24 via 10.3.0.1 dev enp1s0 src 10.3.0.148
ip r add 10.100.0.2/32 via 10.3.0.1 dev enp1s0 src 10.3.0.148
