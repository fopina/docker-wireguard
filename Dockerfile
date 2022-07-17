FROM alpine:3.16

RUN apk add wireguard-tools libqrencode

COPY bin /usr/bin

ENV WG_PORT=51900
ENV WG_CONF_FILE="/etc/wireguard/wg0.conf"
ENV WG_ETH_OUT="eth0"
ENV WG_SUBNET="10.253.3"

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
