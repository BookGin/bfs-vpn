# BFS-VPN

## Introduction

This VPN is based on Algo VPN, which is implemented using strongSwan IPsec IKEv2 VPN.

This repository provides VPN install scripts for different operation systems:

- MAC OSX
- Linux
- Windows 10
- Windows 8

The VPN is used in our CTF team, BFS, which attends DEFCON CTF Final 2018.

Directory hierarchy:
- cloud: where the VPN server installed, rendezvous point in the cloud, with public IP
- onsite: thurconfig is installed in the DEFCON onsite machine
- client: the config is for the clients

## Usage

### Install Algo VPN

[Algo VPN](https://github.com/trailofbits/algo).

- Signing the domain name leads to lots of problems in mac OS X. Please sign the Public IP address.
- It's required to specify `max_mss: 1316` when deploying on the Google Cloud Platform.
- `local_service_ip: 8.8.8.8` (Google Public DNS)
- Keep all the private key since we'll sign our PKCS12 certificates.
- Remember to choose YES for the compatibility of Windows 10.
- Remember to keep the CA password.

For more details, please refer to [cloud/config.cfg](cloud/config.cfg)

### Install The Script Generator

- Specify the password and IP address in `gen-pkcs12.sh`:
```
easyrsa_CA_password=""
IP_subject_alt_name=""
```

Signing the domain name leads to lots of problems in mac OS X. Please sign the Public IP address.

- Install the script Generator
```
cp ./gen-install-script.py algo-git-clone-repo/configs/240.240.240.240/pki
cp ./gen-pkcs12.sh ./algo-git-clone-repo/configs/240.240.240.240/pki
```

### Generate Install Scripts

```
cd algo-git-clone-repo/configs/240.240.240.240/pki
./gen-pkcs12.sh USERNAME
tar zcvf USERNAME.tar.gz USERNAME
```

## Note

- Encrypt PKCS 12: Specify the option `-passout pass:"password_you_like"` in `gen-pkcs12.sh
- You need to set up NAT on the onsite machine yourself.
