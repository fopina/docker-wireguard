# quickstart

```
docker run --name wg \
           -d \
           --privileged \
           -p80:80/udp \
           -r WG_PORT=80 \
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

Available environment variables:

| Name | Description | Default |
| ---- | ----------- | ------- |
| WG_HOST | external hostname, used to generate the client configurations | |
| WG_PORT | listening port | 51900 |
| WG_CONF_FILE | path to configuration file | /etc/wireguard/wg0.conf |
| WG_SUBNET | Subnet prefix to use | 10.253.3 |
| WG_ETH_OUT | wireguard output device to create | wg0 |
