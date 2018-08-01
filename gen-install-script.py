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

def generateMacConfig(username, hostname, p12_base64, cacert_base64, vpnname):
    with open(MAC_TEMPLATE_FILE) as f:
        template = Template(f.read())
    return template.render(
        PayloadContentCA=cacert_base64,
        p12_base64=p12_base64,
        username=username,
        IP_subject_alt_name=hostname,
        vpnname=vpnname,
        uuid=str(uuid4()).upper(),
        pkcs12_PayloadCertificateUUID=str(uuid4()).upper(),
        VPN_PayloadIdentifier=str(uuid4()).upper(),
        CA_PayloadIdentifier=str(uuid4()).upper(),
        PayloadIdentifier=str(uuid4()).upper(),
        PayloadUUID=str(uuid4()).upper(), 
    )

def generateWindowsConfig(username, hostname, p12_base64, cacert_base64, vpnname):
    with open(WINDOWS_TEMPLATE_FILE) as f:
        template = Template(f.read())
    return template.render(
        cacert_base64=cacert_base64,
        p12_base64=p12_base64,
        username=username,
        IP_subject_alt_name=hostname,
        vpnname=vpnname,
    )

def generateLinuxConfig(username, hostname, p12_base64, vpnname):
    with open(LINUX_TEMPLATE_FILE) as f:
        template = Template(f.read())
    return template.render(
        username=username,
        hostname=hostname,
        vpnname=vpnname,
        p12_base64=p12_base64,
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
    with open(argv.p12, 'rb') as f:
        p12_base64 = base64.b64encode(f.read()).decode()
    with open(argv.cacert) as f:
        cacert_base64 = base64.b64encode(f.read().encode()).decode()

    os.mkdir(argv.username)

    windows_config = generateWindowsConfig(argv.username, argv.hostname, p12_base64, cacert_base64, argv.vpnname)
    with open(os.path.join(argv.username, argv.vpnname + "-windows.ps1"), "w") as f:
        f.write(windows_config)

    mac_config = generateMacConfig(argv.username, argv.hostname, p12_base64, cacert_base64, argv.vpnname)
    with open(os.path.join(argv.username, argv.vpnname + "-mac.mobileconfig"), "w") as f:
        f.write(mac_config)
    linux_config = generateLinuxConfig(argv.username, argv.hostname, p12_base64, argv.vpnname)
    with open(os.path.join(argv.username, argv.vpnname + "-linux.sh"), "w") as f:
        f.write(linux_config)

if __name__ == '__main__':
    argv = parseArgv()
    main(argv)
