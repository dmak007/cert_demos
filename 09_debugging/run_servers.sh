#!/bin/bash

# doesnt send cert chain
docker run --name no_server_chain --rm -p 81:443 -d \
    -v $PWD/../static:/usr/share/nginx/html \
    -v $PWD/nginx_configs/no_server_chain.conf:/etc/nginx/conf.d/nginx_config.conf \
    -v $PWD/certs/uozu.server.localhost.crt:/etc/ssl/certs/uozu.server.localhost.crt \
    -v $PWD/certs/uozu.server.localhost.key:/etc/ssl/certs/uozu.server.localhost.key \
    nginx

# sends cert chain
docker run --name server_chain -p 82:443 -d \
    -v $PWD/../static:/usr/share/nginx/html \
    -v $PWD/nginx_configs/server_chain.conf:/etc/nginx/conf.d/nginx_config.conf \
    -v $PWD/certs/uozu.server.localhost.chain.crt:/etc/ssl/certs/uozu.server.localhost.chain.crt \
    -v $PWD/certs/uozu.server.localhost.key:/etc/ssl/certs/uozu.server.localhost.key \
    nginx

# uses uozu.server.com CN
docker run --name not_localhost -p 83:443 -d \
    -v $PWD/../static:/usr/share/nginx/html \
    -v $PWD/nginx_configs/not_localhost.conf:/etc/nginx/conf.d/nginx_config.conf \
    -v $PWD/certs/uozu.server.com.chain.crt:/etc/ssl/certs/uozu.server.com.chain.crt \
    -v $PWD/certs/uozu.server.com.key:/etc/ssl/certs/uozu.server.com.key \
    nginx

# uses uozu.server.localhost cert signed by non-CA (invalid) intermediate cert
docker run --name non_ca -p 84:443 -d \
    -v $PWD/../static:/usr/share/nginx/html \
    -v $PWD/nginx_configs/server_chain.notca.conf:/etc/nginx/conf.d/nginx_config.conf \
    -v $PWD/certs/uozu.server.localhost.notca.chain.crt:/etc/ssl/certs/uozu.server.localhost.notca.chain.crt \
    -v $PWD/certs/uozu.server.localhost.key:/etc/ssl/certs/uozu.server.localhost.key \
    nginx
