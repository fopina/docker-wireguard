#!/bin/sh

if [ ! -e "${WG_CONF_FILE}" ]; then
    echo "${WG_CONF_FILE} not found, generating one"
    wg genkey | tee /etc/wireguard/server.key | wg pubkey > /etc/wireguard/server.pub
    cat <<EOF > ${CONF_FILE}
[Interface]
Address = ${WG_SUBNET}.1/24
SaveConfig = true
PrivateKey = `cat /etc/wireguard/server.key`
ListenPort = ${WG_PORT}

PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o ${WG_ETH_OUT} -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o ${WG_ETH_OUT} -j MASQUERADE

EOF
    add_peer.sh peer1 ${WG_SUBNET}.2
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
