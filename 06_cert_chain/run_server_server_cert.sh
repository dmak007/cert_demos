#!/bin/bash

docker run -p 443:443 -d \
    -v $PWD/../static:/usr/share/nginx/html \
    -v $PWD/nginx_config_server.conf:/etc/nginx/conf.d/nginx_config_server.conf \
    -v $PWD/certs/uozuaho.com.crt:/etc/ssl/certs/uozuaho.com.crt \
    -v $PWD/certs/uozuaho.com.key:/etc/ssl/certs/uozuaho.com.key \
    nginx
