#!/usr/bin/env bash

set -e

if [ `whoami` != 'root' ]; then
  echo "You must be root"
  exit -1
fi

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 username"
  exit -1
fi

cd /etc/ipsec.d/
mkdir -p p12

# Client cert
name=$1
key=private/${name}-key.pem
cert=certs/${name}-cert.pem
p12cert=p12/${name}.p12
cn="C=TW, O=BFS, CN=$name"

ipsec pki --gen --type ecdsa --outform pem > $key
chmod 600 $key
ipsec pki --pub --in $key --type ecdsa \
| ipsec pki --issue --lifetime 180 --outform pem \
--cacert cacerts/cacert.pem \
--cakey private/cakey.pem \
--dn "$cn" \
--san "$name" \
> $cert

# Pack to PKCS#12 file
openssl pkcs12 -export -name "Client certificate for $name" \
-inkey $key \
-in $cert  \
-certfile cacerts/cacert.pem \
-caname "BFS Root CA" \
-out $p12cert
chmod 600 $p12cert
