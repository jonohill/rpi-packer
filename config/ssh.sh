#!/bin/bash

# Sets up SSH server
# SSH_KEY: public key for `pi` user
# SSH_CA_KEY: SSH CA private key, base64. Signs host key, not saved.

echo Start ssh

set -e

systemctl enable ssh
mkdir -p /home/pi/.ssh
echo "${SSH_KEY}" >> /home/pi/.ssh/authorized_keys


if ! [[ -z "${SSH_CA_KEY}" ]]; then
    systemctl disable regenerate_ssh_host_keys.service

    tmp_dir="$(mktemp -d)"
    trap "rm -rf "$tmp_dir"" EXIT
    ca_key_file="${tmp_dir}/ca_key"
    # Try to treat as base64 encoded to start with, else raw
    if ! echo "${SSH_CA_KEY}" | base64 -d >"$ca_key_file"; then
        echo "${SSH_CA_KEY}" >"$ca_key_file"
    fi
    chmod 600 "$ca_key_file"

    mkdir -p /etc/ssh
    yes | ssh-keygen -t ed25519 -f "/etc/ssh/ssh_host_key" -N ''
    ssh-keygen -s "$ca_key_file" -I "$(date +%s)" -z "$(date +%s)" -h "/etc/ssh/ssh_host_key"

    cat >>/etc/ssh/sshd_config <<EOF

HostKey /etc/ssh/ssh_host_key
HostCertificate /etc/ssh/ssh_host_key-cert.pub

PasswordAuthentication no

EOF

fi 

echo End ssh
