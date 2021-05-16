#!/bin/sh

if [ -z "$1" ]; then
    echo "Usage: $0 peer_name"
    exit 2
fi

PEER_NAME=$1

qrencode -t ansiutf8 < /etc/wireguard/${PEER_NAME}.conf
