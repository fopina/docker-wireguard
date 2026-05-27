# quickstart

```
docker run --name wg \
           -d \
           --privileged \
           -p80:80/udp \
           -e WG_PORT=80 \
           -v test:/etc/wireguard \
           fopina/wireguard
```

Helper scripts to manage peers:

```
docker exec -ti wg add_peer.sh peer1 10.253.3.2
```

```
docker exec -ti wg show_peer.sh peer1
```

## client

To use this image as a WireGuard client, mount an existing WireGuard
configuration file and point `WG_CONF_FILE` at it. The container will skip server
configuration generation and run `wg-quick up` with that file.

For example, save your client configuration as `client.conf` and run:

```
docker run --name wg-client \
           -d \
           --privileged \
           -e WG_CONF_FILE=/etc/wireguard/client.conf \
           -v "$PWD/client.conf:/etc/wireguard/client.conf:ro" \
           fopina/wireguard
```

There is also a Compose example that brings up the client and runs a one-shot
`curl` container through the WireGuard network namespace. Save your client
configuration as `examples/client.conf`, then run:

```
WG_CONF_FILE=/tmp/wg-client.conf docker compose -f examples/docker-compose.yml up --build --abort-on-container-exit --exit-code-from ip-check
```

Compose will stop the WireGuard client after `ip-check` exits, and the command
will return the `ip-check` exit code. The Compose example uses `WG_CONF_FILE`
for both the container environment and the mount target.

Example client configuration:

```
[Interface]
PrivateKey = <client private key>
Address = 10.253.3.2/32
DNS = 1.1.1.1, 1.0.0.1

[Peer]
PublicKey = <server public key>
AllowedIPs = 0.0.0.0/0
Endpoint = vpn.example.com:51900
PersistentKeepalive = 25
```

Available environment variables:

| Name | Description | Default |
| ---- | ----------- | ------- |
| WG_HOST | external hostname, used to generate the client configurations | |
| WG_PORT | listening port | 51900 |
| WG_CONF_FILE | path to configuration file | /etc/wireguard/wg0.conf |
| WG_SUBNET | Subnet prefix to use | 10.253.3 |
| WG_ETH_OUT | output device to create | eth0 |
