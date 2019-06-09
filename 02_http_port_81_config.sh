#!/bin/bash

docker run -p 81:81 -d \
    -v $PWD/static:/usr/share/nginx/html\
    -v $PWD/02_config.conf:/etc/nginx/conf.d/02_config.conf\
    nginx
