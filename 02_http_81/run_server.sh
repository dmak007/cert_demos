#!/bin/bash

docker run -p 81:81 -d \
    -v $PWD/../static:/usr/share/nginx/html\
    -v $PWD/nginx_config.conf:/etc/nginx/conf.d/nginx_config.conf\
    nginx
