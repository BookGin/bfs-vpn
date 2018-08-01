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

# Specify host key in the ipsec.secrets
cat << EOF > /etc/ipsec.secrets
# ipsec.secrets - strongSwan IPsec secrets file

: ECDSA hostkey.pem
EOF
chmod 600 /etc/ipsec.secrets

# Specify host key in the ipsec.secrets
cat << EOF > /etc/ipsec.conf
# ipsec.conf - strongSwan IPsec configuration file
config setup
        # strictcrlpolicy=yes
        # uniqueids = no
        # charondebug="cfg 2, dmn 2, ike 2, net 2"

conn %default
        ikelifetime=60m
        keylife=30m
        rekeymargin=3m
        keyingtries=1
        keyexchange=ikev2

        ike=aes256gcm16-prfsha512-ecp384,aes256-sha2_512-prfsha512-ecp384,aes256-sha2_384-prfsha384-ecp384
        esp=aes256gcm16-ecp384,aes256-sha2_512-prfsha512-ecp384

conn client
        # local: cloud
        left=10.140.0.2 #%defaultroute
        leftsubnet=10.140.0.2, 10.10.10.0/24
        leftfirewall=yes

        leftauth=pubkey
        leftcert=vpn.bfs.tw.pem
        leftid=vpn.bfs.tw

        # remote: VPN client
        right=%any
        # must omit: rightsubnet=...
        rightsourceip=10.10.10.1/24
        rightauth=pubkey
        auto=add
EOF
