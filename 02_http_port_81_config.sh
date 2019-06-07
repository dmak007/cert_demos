#!/bin/bash
# run this with MSYS_NO_PATHCONV=1, because everything has to be difficult

# Demo custom nginx config by running the http server on port 81

docker run -p 81:81 -d \
    -v $PWD/static:/usr/share/nginx/html\
    -v $PWD/02_config.conf:/etc/nginx/conf.d/02_config.conf\
    nginx
