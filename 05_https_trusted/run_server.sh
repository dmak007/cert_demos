#!/bin/bash

docker network prune -f

docker network create --driver=bridge 05_net

docker run -d \
    -v $PWD/../static:/usr/share/nginx/html \
    -v $PWD/nginx_config.conf:/etc/nginx/conf.d/nginx_config.conf \
    -v $PWD/server.crt:/etc/ssl/certs/server.crt \
    -v $PWD/server.key:/etc/ssl/certs/server.key \
    --network 05_net \
    nginx
