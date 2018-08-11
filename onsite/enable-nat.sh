#!/usr/bin/env bash
bash -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
iptables -t nat -A POSTROUTING -s 10.87.87.0/24 -o enp1s0 -m policy --dir out --pol ipsec -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.87.87.0/24 -o enp1s0 -j MASQUERADE
