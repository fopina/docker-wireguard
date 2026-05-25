> No longer maintained, I've moved to tailscale

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

To use this image as a WireGuard client, provide an existing WireGuard
configuration file. When `WG_CONF_FILE` already exists, the container skips the
server configuration generation and runs `wg-quick up` with that file.

For example, save your client configuration as `wg0.conf` and run:

```
docker run --name wg-client \
           -d \
           --privileged \
           -v "$PWD/wg0.conf:/etc/wireguard/wg0.conf:ro" \
           fopina/wireguard
```

The client configuration can include a `DNS = ...` line. The entrypoint prepares
`resolvconf` before starting WireGuard so `wg-quick` can apply those DNS
settings.

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
