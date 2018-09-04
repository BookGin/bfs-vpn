#!/usr/bin/env bash

set -e

name=$1
easyrsa_CA_password=""
IP_subject_alt_name=""
subjectAltName="IP:$IP_subject_alt_name"
#subjectAltName="IP:$IP_subject_alt_name,DNS:example.com"

openssl req -utf8 -new \
-newkey ec:ecparams/secp384r1.pem \
-config <(cat openssl.cnf <(printf "[basic_exts]\nsubjectAltName=DNS:$name")) \
-keyout private/$name.key \
-out reqs/$name.req -nodes \
-passin pass:"$easyrsa_CA_password" \
-subj "/CN=$name" -batch 

openssl ca -utf8 \
-in reqs/$name.req \
-out certs/$name.crt \
-config <(cat openssl.cnf <(printf "[basic_exts]\nsubjectAltName=DNS:$name")) \
-days 3650 -batch \
-passin pass:"$easyrsa_CA_password" \
-subj "/CN=$name"

openssl pkcs12 \
-in certs/$name.crt \
-inkey private/$name.key \
-export \
-name $name \
-out private/$name.p12
#-passout pass:"{{ easyrsa_p12_export_password }}"

./gen-install-script.py --username $name \
--hostname $IP_subject_alt_name \
--p12 private/$name.p12 \
--cacert cacert.pem \
--vpnname $vpnname
