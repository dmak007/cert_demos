#!/bin/bash

# Generate a certificate and private key

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -subj "/C=AU/CN=my_common_name/emailAddress=me@me.com" \
            -keyout server.key -out server.crt
