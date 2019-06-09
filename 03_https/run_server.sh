#!/bin/bash

docker run -i -t -p 443:443 -d \
    -v $PWD/../static:/usr/share/nginx/html \
    -v $PWD/nginx_config.conf:/etc/nginx/conf.d/nginx_config.conf \
    -v $PWD/certificate.crt:/etc/ssl/certs/certificate.crt \
    -v $PWD/private_key.key:/etc/ssl/certs/private_key.key \
    nginx
