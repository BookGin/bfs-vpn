#!/usr/bin/env bash

set -e

if [ `whoami` != 'root' ]; then
  echo "You must be root"
  exit -1
fi

#apt update
#apt upgrade
#apt install strongswan strongswan-pki

cd /etc/ipsec.d

# CA root cert
ipsec pki --gen --type ecdsa --outform pem > private/cakey.pem
chmod 600 private/cakey.pem
ipsec pki --self --ca --lifetime 365 --outform pem --in private/cakey.pem --type ecdsa --dn "C=TW, O=BFS, CN=BFS Root CA" > cacerts/cacert.pem

# Host cert
ipsec pki --gen --type ecdsa --outform pem > private/hostkey.pem
chmod 600 private/hostkey.pem
ipsec pki --pub --type ecdsa --in private/hostkey.pem \
| ipsec pki --issue --lifetime 180 --outform pem \
--cacert cacerts/cacert.pem \
--cakey private/cakey.pem \
--dn "C=TW, O=BFS, CN=vpn.bfs.tw" \
--san vpn.bfs.tw \
--flag serverAuth --flag ikeIntermediate \
> certs/vpn.bfs.tw.pem
