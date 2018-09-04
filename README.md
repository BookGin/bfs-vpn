# BFS-VPN

## Introduction

This VPN is based on Algo VPN, which is implemented using strongSwan IPsec IKEv2 VPN.

This repository provides VPN install scripts for different operation systems:

- MAC OSX
- Linux
- Windows 10
- Windows 8

The VPN is used in our CTF team, BFS, which attends DEFCON CTF Final 2018.

## Install

### Install Algo VPN

[Algo VPN](https://github.com/trailofbits/algo).

- Signing the domain name leads to lots of problems in mac OS X. Please sign the Public IP address.
- It's required to specify `max_mss: 1316` when deploying on the Google Cloud Platform.
- `local_service_ip: 8.8.8.8` (Google Public DNS)
- Keep all the private key since we'll sign our PKCS12 certificates.
- Remember to choose YES for the compatibility of Windows 10.
- Remember to keep the CA password.

For more details, please refer to [config.cfg](config.cfg)
