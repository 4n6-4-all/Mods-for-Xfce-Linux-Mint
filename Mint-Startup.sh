#!/bin/bash

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root (use sudo)"
    exit 1
fi

echo "=============================================="
echo "          Setting up firewall "
echo "=============================================="
sleep 2
ufw enable
ufw default deny incoming
echo "=============================================="
echo " Setting system-wide DNS over TLS with Quad9 "
echo "=============================================="
sleep 2
sed -i 's/\#DNS=/DNS=9.9.9.9#dns.quad9.net/' /etc/systemd/resolved.conf
sed -i 's/\#FallbackDNS=/FallbackDNS=149.112.112.112#dns.quad9.net/' /etc/systemd/resolved.conf
sed -i 's/\#DNSSEC=no/DNSSEC=no/' /etc/systemd/resolved.conf
sed -i 's/\#DNSOverTLS=no/DNSOverTLS=yes/' /etc/systemd/resolved.conf
echo "========================================"
echo " Restarting resolved and NetworkManager "
echo "========================================"
sleep 2
systemctl restart systemd-resolved.service
systemctl restart NetworkManager.service
echo "=========================================="
echo "Setting GRUB to show boot logs at startup"
echo "=========================================="
sleep 2
sed -i 's/quiet splash/profile/' /etc/default/grub
update-grub2
echo "========================================="
echo "Copying policies.json to Firefox directory"
echo "========================================="
sleep 2
mkdir -p /etc/firefox/policies
cp policies.json /etc/firefox/policies
echo "================================================="
echo "      Creating encrypted apt mirrors"
echo "================================================="
sleep 2
sed -i 's/http:/https:/g' /etc/apt/sources.list.d/official-package-repositories.list
sed -i 's/packages.linuxmint.com/mirrors.ocf.berkeley.edu\/linuxmint-packages/' /etc/apt/sources.list.d/official-package-repositories.list
sleep 2
echo "========================================="
echo "      Removing bloated apps"
echo "========================================="
sleep 2
apt-get purge avahi* -y
apt-get purge Modemanager -y
apt-get purge kerneloops -y
apt-get purge rhythmbox* -y
apt-get purge libreoffice* -y
apt-get purge sticky -y
apt-get purge webapp-manager -y
apt-get purge mintchat -y
apt-get purge transmission* -y
apt-get purge cups* -y
apt-get purge network-manager-config-connectivity-ubuntu -y
echo "========================================="
echo "          Installing apps"
echo "========================================="
sleep 2
apt update && apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager wireshark zenmap wxhexeditor bleachbit binwalk secure-delete gparted opensnitch apt-transport-https
echo "================================================="
echo "         Completed modifications"
echo "================================================="
sleep 2
exit 1
