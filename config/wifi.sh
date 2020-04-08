#!/bin/bash

echo Start wifi

set -e

mkdir -p /etc/wpa_supplicant || true
printf "${WIFI_PASSWORD}" | wpa_passphrase "${WIFI_SSID}" >/etc/wpa_supplicant/wpa_supplicant.conf

echo End wifi
