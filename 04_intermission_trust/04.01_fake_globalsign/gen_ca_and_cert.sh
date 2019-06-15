#!/bin/bash

# generate fake GlobalSign CA certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -subj "/OU=GlobalSign Root CA - R3/O=GlobalSign/CN=GlobalSign" \
            -keyout fake_globalsign.key -out fake_globalsign.crt

# generate a certificate request
openssl req -nodes -newkey rsa:2048 \
    -subj "/C=AU/CN=my_common_name/emailAddress=me@me.com" \
    -keyout private_key.key -out certificate.csr

# sign our certificate with the fake GlobalSign CA:
openssl x509 -req -in certificate.csr -CA fake_globalsign.crt -CAkey fake_globalsign.key \
    -CAcreateserial -out certificate.crt
