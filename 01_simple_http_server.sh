#!/bin/bash
# run this with MSYS_NO_PATHCONV=1, because everything has to be difficult

# Serve a single html page over http. Run this then browse to localhost

docker run -p 80:80 -d -v $PWD/static:/usr/share/nginx/html nginx
