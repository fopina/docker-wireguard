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
