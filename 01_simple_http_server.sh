#!/bin/bash

docker run -p 80:80 -d -v $PWD/static:/usr/share/nginx/html nginx
