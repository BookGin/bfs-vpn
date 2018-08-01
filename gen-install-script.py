#!/usr/bin/env python3
import argparse
import sys
import os
import base64

from jinja2 import Template
from uuid import uuid4

MAC_TEMPLATE_FILE='templates/mac.mobileconfig.j2'
WINDOWS_TEMPLATE_FILE='templates/windows.ps1.j2'
LINUX_TEMPLATE_FILE='templates/linux.sh.j2'

def generateMacConfig(username, hostname, p12_base64, cacert_base64, vpn_name):
    with open(WINDOWS_TEMPLATE_FILE) as f:
        template = Template(f.read())
    return template.render(
        PayloadContentCA=cacert_base64,
        p12_base64=p12_base64,
        username=username,
        IP_subject_alt_name=hostname,
        vpn_name=vpn_name,
        uuid=str(uuid4()).upper(),
        pkcs12_PayloadCertificateUUID=str(uuid4()).upper(),
        VPN_PayloadIdentifier=str(uuid4()).upper(),
        CA_PayloadIdentifier=str(uuid4()).upper(),
        PayloadIdentifier=str(uuid4()).upper(),
        PayloadUUID=str(uuid4()).upper(), 
    )

def generateWindowsConfig(username, hostname, p12_base64, cacert_base64, vpn_name):
    with open(WINDOWS_TEMPLATE_FILE) as f:
        template = Template(f.read())
    return template.render(
        cacert_base64=cacert_base64,
        p12_base64=p12_base64,
        username=username,
        IP_subject_alt_name=hostname,
        vpn_name=vpn_name,
    )

def generateLinuxConfig(username, hostname, p12_cert, vpn_name):
    with open(LINUX_TEMPLATE_FILE) as f:
        template = Template(f.read())
    return template.render(
        username=username,
        hostname=hostname,
        vpn_name=vpn_name,
        p12_cert=p12_cert,
    )

def parseArgv():
    parser = argparse.ArgumentParser(prog=sys.argv[0])
    parser.add_argument('--username', type=str, required=True)
    parser.add_argument('--hostname', type=str, required=True)
    parser.add_argument('--p12', type=str, required=True)
    parser.add_argument('--cacert', type=str, required=True)
    parser.add_argument('--vpnname', type=str, required=True)
    return parser.parse_args()

def main(argv):
    with open(argv.p12) as f:
        p12_cert = f.read()
        p12_base64 = base64.b64encode(p12_cert).decode()
    with open(argv.cacert) as f:
        cacert_base64 = base64.b64encode(f.read()).decode()

    os.mkdir(argv.username)

    windows_config = generateWindoesConfig(argv.username, argv.hostname, p12_base64, cacert_base64, argv.vpnname)
    with open(os.path.join(argv.username, argv.vpnname + "-windows.ps1"), "wb") as f:
        f.write(windows_config)

    mac_config = generateMacConfig(argv.username, argv.hostname, p12_base64, cacert_base64, argv.vpnname)
    with open(os.path.join(argv.username, argv.vpnname + "-mac.mobileconfig"), "wb") as f:
        f.write(mac_config)
    linux_config = generateLinuxConfig(argv.username, argv.hostname, p12_cert, argv.vpnname)
    with open(os.path.join(argv.username, argv.vpnname + "-linux.sh"), "wb") as f:
        f.write(linux_config)

if __name__ == '__main__':
    argv = parseArgv()
    main(argv)
