#!/bin/bash

# Generate server cert
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -subj "/C=AU/CN=localhost/emailAddress=me@me.com" \
            -keyout server.key -out server.crt

# client cert
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -subj "/C=AU/CN=mr_client/emailAddress=mr_client@me.com" \
            -keyout client.key -out client.crt
