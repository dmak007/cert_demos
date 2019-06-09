#!/bin/bash

docker run -i -t -p 443:443 -d \
    -v $PWD/static:/usr/share/nginx/html \
    -v $PWD/03_config.conf:/etc/nginx/conf.d/03_config.conf \
    -v $PWD/certs:/etc/ssl/certs \
    nginx
