#!/usr/bin/env bash

bash -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o ens4 -m policy --dir out --pol ipsec -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o ens4 -j MASQUERADE

# delete: replace -A with -D
