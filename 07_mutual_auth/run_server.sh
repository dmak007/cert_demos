#!/bin/bash

docker run -p 443:443 -d \
    -v $PWD/../static:/usr/share/nginx/html \
    -v $PWD/nginx_config.conf:/etc/nginx/conf.d/nginx_config.conf \
    -v $PWD/server.crt:/etc/ssl/certs/server.crt \
    -v $PWD/client.crt:/etc/ssl/certs/client.crt \
    -v $PWD/server.key:/etc/ssl/certs/server.key \
    nginx
