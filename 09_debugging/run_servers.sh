#!/bin/bash

docker run --name no_server_chain --rm -p 81:443 -d \
    -v $PWD/../static:/usr/share/nginx/html \
    -v $PWD/nginx_configs/no_server_chain.conf:/etc/nginx/conf.d/nginx_config.conf \
    -v $PWD/certs/uozu.server.crt:/etc/ssl/certs/uozu.server.crt \
    -v $PWD/certs/uozu.server.key:/etc/ssl/certs/uozu.server.key \
    nginx

docker run --name server_chain -p 82:443 -d \
    -v $PWD/../static:/usr/share/nginx/html \
    -v $PWD/nginx_configs/server_chain.conf:/etc/nginx/conf.d/nginx_config.conf \
    -v $PWD/certs/uozu.server.chain.reversed.crt:/etc/ssl/certs/uozu.server.chain.reversed.crt \
    -v $PWD/certs/uozu.server.key:/etc/ssl/certs/uozu.server.key \
    nginx