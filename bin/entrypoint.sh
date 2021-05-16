#!/bin/sh

CONF_FILE="/etc/wireguard/wg0.conf"
if [ ! -e "${CONF_FILE}" ]; then
    echo "${CONF_FILE} not found, generating one"
    wg genkey | tee /etc/wireguard/server.key | wg pubkey > /etc/wireguard/server.pub
    cat <<EOF > ${CONF_FILE}
[Interface]
Address = 10.253.3.1/24
SaveConfig = true
PrivateKey = `cat /etc/wireguard/server.key`
ListenPort = 51900

PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

EOF
    add_peer.sh peer1 10.253.3.2
fi


# same as https://github.com/linuxserver/docker-wireguard/blob/master/root/etc/services.d/wireguard/run

_term() {
  echo "Caught SIGTERM signal!"
  wg-quick down wg0
}

trap _term SIGTERM

wg-quick up wg0

sleep infinity &

wait
