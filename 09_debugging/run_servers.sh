#!/bin/bash

docker run -p 81:443 -d \
    -v $PWD/../static:/usr/share/nginx/html \
    -v $PWD/nginx_configs/no_server_chain.conf:/etc/nginx/conf.d/nginx_config.conf \
    -v $PWD/certs/uozu.server.crt:/etc/ssl/certs/uozu.server.crt \
    -v $PWD/certs/uozu.server.key:/etc/ssl/certs/uozu.server.key \
    nginx
