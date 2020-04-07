#!/bin/bash

set -e

mkdir -p /etc/wpa_supplicant
printf "${WIFI_PASSWORD}" | wpa_passphrase "${WIFI_SSID}" >/etc/wpa_supplicant/wpa_supplicant.conf
