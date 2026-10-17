#!/bin/sh

if [ -z "$1" ]; then
    echo "Usage: $0 peer_name"
    exit 2
fi

PEER_NAME=$1

case "$PEER_NAME" in
    ''|*[!A-Za-z0-9_-]*)
        echo "Peer name may contain only letters, numbers, underscores, and hyphens" >&2
        exit 2
        ;;
esac

qrencode -t ansiutf8 < "/etc/wireguard/${PEER_NAME}.conf"
