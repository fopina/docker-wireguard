FROM alpine:3.12

RUN apk add wireguard-tools libqrencode

COPY bin /usr/bin

ENV WG_PORT=51900
ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
