#!/bin/sh

CONF_FILE="/etc/wireguard/wg0.conf"

if [ -z "$2" ]; then
    echo "Usage: $0 peer_name peer_ip"
    exit 2
fi

PEER_NAME=$1
PEER_IP=$2

if [ -z "${WG_HOST}" ]; then
    WG_HOST=`wget icanhazip.com -O /dev/stdout -q`
fi

wg genkey | tee /etc/wireguard/${PEER_NAME}.key | wg pubkey > /etc/wireguard/${PEER_NAME}.pub

echo >> ${CONF_FILE}

cat <<EOF >> ${CONF_FILE}
[Peer]
PublicKey = `cat /etc/wireguard/${PEER_NAME}.pub`
AllowedIPs = ${PEER_IP}/32
EOF

cat <<EOF > /etc/wireguard/${PEER_NAME}.conf
[Interface]
PrivateKey = `cat /etc/wireguard/${PEER_NAME}.key`
Address = ${PEER_IP}/32
DNS = 1.1.1.1, 1.0.0.1

[Peer]
PublicKey = `cat /etc/wireguard/server.pub`
AllowedIPs = 0.0.0.0/0
Endpoint = ${WG_HOST}:${WG_PORT}
EOF

echo "Generated one peer conf at /etc/wireguard/${PEER_NAME}.conf"

qrencode -t ansiutf8 < /etc/wireguard/${PEER_NAME}.conf
