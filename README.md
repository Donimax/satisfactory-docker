# satisfactory-docker

[![Docker Pulls](https://img.shields.io/docker/pulls/donimax/satisfactory-docker)](https://hub.docker.com/r/donimax/satisfactory-docker)
[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/donimax/satisfactory-docker/latest)](https://hub.docker.com/r/donimax/satisfactory-docker)

This is a Dockerized version of the [Satisfactory](https://store.steampowered.com/app/526870/Satisfactory/) dedicated server.

## Docker-compose file

```yaml
version: '3'
services:
    satisfactory-server-01:
        container_name: 'satisfactory-server-01'
        hostname: 'satisfactory-server-01'
        image: 'donimax/satisfactory-docker:latest'
        ports:
            - '7777:7777/udp'
            - '15000:15000/udp'
            - '15777:15777/udp'
        volumes:
            - 'opt/docker/satisfactory/config:/config'
        environment:
            - MAXPLAYERS=8
            - PGID=1000
            - PUID=1000
            - STEAMBETA=false
            - SERVERBEACONPORT=15000
            - SERVERGAMEPORT=7777
            - SERVERIP=0.0.0.0
            - SERVERQUERYPORT=15777
            - SKIPUPDATE=false
            - STEAMAPPID=1690800
        restart: unless-stopped
```

For windows volumes use for example:

```yaml
        volumes:
            - 'c:/docker/satisfactory/config:/config'
```
