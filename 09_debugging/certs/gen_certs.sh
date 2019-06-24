#!/bin/bash

# generate root CA cert
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -subj "/OU=UozuSign Root CA/O=UozuSign/CN=UozuSign" \
            -keyout uozusign_root.key -out uozusign_root.crt

# generate intermediate certificate request
openssl req -nodes -newkey rsa:2048 \
    -addext basicConstraints=CA:TRUE \
    -subj "/OU=UozuSign Intermediate CA/O=UozuSign intermediate/CN=UozuSign intermediate" \
    -keyout uozusign_intermediate.key -out uozusign_intermediate.csr

# sign intermediate certificate with the root CA
# Note the '-extensions v3_ca' parameters. This is to set this
# certificate to be a CA. openssl verify fails otherwise, since
# the standard states that only CA certs are allowed to sign other
# certs
openssl x509 -req -days 365 -in uozusign_intermediate.csr \
    -extensions v3_ca -extfile uozusign_intermediate.conf \
    -CA uozusign_root.crt -CAkey uozusign_root.key \
    -CAcreateserial -out uozusign_intermediate.crt

# generate server certificate request
openssl req -nodes -newkey rsa:2048 \
    -subj "/C=AU/CN=uozu.server/emailAddress=me@me.com" \
    -keyout uozu.server.key -out uozu.server.csr

# sign server certificate with the intermediate CA:
openssl x509 -req -days 365 -in uozu.server.csr -CA uozusign_intermediate.crt \
    -CAkey uozusign_intermediate.key -CAcreateserial -out uozu.server.crt

# create certificate chain to root (don't include the root)
cat uozusign_intermediate.crt uozu.server.crt > uozu.server.chain.crt

# create certificate chain in wrong order
cat uozu.server.crt uozusign_intermediate.crt > uozu.server.chain.reversed.crt

# generate client certificate request
openssl req -nodes -newkey rsa:2048 \
    -subj "/C=AU/CN=uozu_client/emailAddress=me@me.com" \
    -keyout uozu.client.key -out uozu.client.csr

# sign server certificate with the intermediate CA:
openssl x509 -req -days 365 -in uozu.client.csr -CA uozusign_intermediate.crt \
    -CAkey uozusign_intermediate.key -CAcreateserial -out uozu.client.crt

# create certificate chain to root (don't include the root)
cat uozu.client.crt uozusign_intermediate.crt > uozu.client.chain.crt
