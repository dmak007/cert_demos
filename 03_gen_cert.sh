#!/bin/bash

# Generate a certificate and private key

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -subj "/C=AU/CN=my_common_name/emailAddress=me@me.com" \
            -keyout certs/03.key -out certs/03.crt

# req:    certificate request and certificate generating utility
# x509:   output self signed cert instead of cert request
# nodes:  No-DES, ie. don't use DES (or anything) to encrypt the private key.
#         In other words, don't encrypt the private key.
# days:   set cert expiry in N days
# newkey: generate a new certificate (or request) and private key
# subj:   set certificate subject fields
# keyout: path the write private key
# out:    path to write certificate