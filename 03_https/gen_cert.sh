#!/bin/bash

# Generate a certificate and private key

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -subj "/C=AU/CN=my_common_name/emailAddress=me@me.com" \
            -keyout private_key.key -out certificate.crt

# req:    certificate request and certificate generating utility
# x509:   output self signed cert instead of cert request
# nodes:  No-DES, ie. don't use DES (or anything) to encrypt the private key.
#         In other words, don't encrypt the private key.
# days:   set cert expiry in N days
# newkey: generate a new certificate (or request) and private key
# subj:   set certificate subject fields
# keyout: path the write private key
# out:    path to write certificate

# encrypt the private key
openssl rsa -aes256 -passout pass:1234 -in private_key.key -out private_key_encrypted.key
