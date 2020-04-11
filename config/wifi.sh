#!/bin/bash

echo Start wifi

set -e

mkdir -p /etc/wpa_supplicant || true
printf "${WIFI_PASSWORD}" | wpa_passphrase "${WIFI_SSID}" >/etc/wpa_supplicant/wpa_supplicant.conf

cat >>/etc/network/interfaces <<EOF

allow-hotplug wlan0
iface wlan0 inet manual
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

EOF

systemctl enable wpa_supplicant.service

echo End wifi
