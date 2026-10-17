#!/bin/sh

umask 077

CONF_FILE="${WG_CONF_FILE:-/etc/wireguard/wg0.conf}"

if [ -z "$2" ]; then
    echo "Usage: $0 peer_name peer_ip"
    exit 2
fi

PEER_NAME=$1
PEER_IP=$2

case "$PEER_NAME" in
    ''|*[!A-Za-z0-9_-]*)
        echo "Peer name may contain only letters, numbers, underscores, and hyphens" >&2
        exit 2
        ;;
esac

if ! awk -F. 'NF == 4 { for (i = 1; i <= 4; i++) if ($i !~ /^[0-9]+$/ || $i > 255) exit 1; next } { exit 1 }' <<EOF
${PEER_IP}
EOF
then
    echo "Peer IP must be a valid IPv4 address" >&2
    exit 2
fi

if [ ! -f "$CONF_FILE" ]; then
    echo "WireGuard configuration not found: $CONF_FILE" >&2
    exit 1
fi

if [ -e "/etc/wireguard/${PEER_NAME}.key" ] || [ -e "/etc/wireguard/${PEER_NAME}.conf" ]; then
    echo "Peer files already exist for ${PEER_NAME}" >&2
    exit 1
fi

if [ -z "${WG_HOST}" ]; then
    WG_HOST=`wget icanhazip.com -O /dev/stdout -q`
fi

wg genkey | tee "/etc/wireguard/${PEER_NAME}.key" | wg pubkey > "/etc/wireguard/${PEER_NAME}.pub"

echo >> "$CONF_FILE"

cat <<EOF >> "$CONF_FILE"
[Peer]
PublicKey = `cat /etc/wireguard/${PEER_NAME}.pub`
AllowedIPs = ${PEER_IP}/32
EOF

cat <<EOF > "/etc/wireguard/${PEER_NAME}.conf"
[Interface]
PrivateKey = `cat /etc/wireguard/${PEER_NAME}.key`
Address = ${PEER_IP}/32
DNS = 1.1.1.1, 1.0.0.1

[Peer]
PublicKey = `cat /etc/wireguard/server.pub`
AllowedIPs = 0.0.0.0/0
Endpoint = ${WG_HOST}:${WG_PORT}
EOF

chmod 600 "/etc/wireguard/${PEER_NAME}.key" "/etc/wireguard/${PEER_NAME}.conf"

echo "Generated one peer conf at /etc/wireguard/${PEER_NAME}.conf"
echo "Restart the WireGuard interface for this peer to take effect."

qrencode -t ansiutf8 < "/etc/wireguard/${PEER_NAME}.conf"
