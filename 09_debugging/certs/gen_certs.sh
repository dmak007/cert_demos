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

# generate non-CA (invalid) intermediate certificate request
openssl req -nodes -newkey rsa:2048 \
    -subj "/OU=UozuSign Intermediate CA/O=UozuSign intermediate/CN=UozuSign intermediate" \
    -key uozusign_intermediate.key -out uozusign_intermediate.notca.csr

# sign intermediate certificate with the root CA
# Note the '-extensions v3_ca' parameters. This is to set this
# certificate to be a CA. openssl verify fails otherwise, since
# the standard states that only CA certs are allowed to sign other
# certs
openssl x509 -req -days 365 -in uozusign_intermediate.csr \
    -extensions v3_ca -extfile uozusign_intermediate.conf \
    -CA uozusign_root.crt -CAkey uozusign_root.key \
    -CAcreateserial -out uozusign_intermediate.crt

# sign the non-CA intermediate cert
openssl x509 -req -days 365 -in uozusign_intermediate.notca.csr \
    -CA uozusign_root.crt -CAkey uozusign_root.key \
    -CAcreateserial -out uozusign_intermediate.notca.crt

# generate server certificate request
openssl req -nodes -newkey rsa:2048 \
    -subj "/C=AU/CN=localhost/emailAddress=me@me.com" \
    -keyout uozu.server.localhost.key -out uozu.server.localhost.csr

# generate server certificate (with uozu.server.com CN) request
openssl req -nodes -newkey rsa:2048 \
    -subj "/C=AU/CN=uozu.server.com/emailAddress=me@me.com" \
    -keyout uozu.server.com.key -out uozu.server.com.csr

# sign server certificate with the intermediate CA:
openssl x509 -req -days 365 -in uozu.server.localhost.csr -CA uozusign_intermediate.crt \
    -CAkey uozusign_intermediate.key -CAcreateserial -out uozu.server.localhost.crt

# sign server certificate with the invalid non-CA intermediate CA:
openssl x509 -req -days 365 -in uozu.server.localhost.csr -CA uozusign_intermediate.notca.crt \
    -CAkey uozusign_intermediate.key -CAcreateserial -out uozu.server.localhost.notca.crt

# sign server certificate (with uozu.server.com CN) with the intermediate CA:
openssl x509 -req -days 365 -in uozu.server.com.csr -CA uozusign_intermediate.crt \
    -CAkey uozusign_intermediate.key -CAcreateserial -out uozu.server.com.crt

# create server certificate chains
cat uozu.server.localhost.crt uozusign_intermediate.crt > uozu.server.localhost.chain.crt
cat uozu.server.localhost.notca.crt uozusign_intermediate.notca.crt > uozu.server.localhost.notca.chain.crt
cat uozu.server.com.crt uozusign_intermediate.crt > uozu.server.com.chain.crt

# generate client certificate request
openssl req -nodes -newkey rsa:2048 \
    -subj "/C=AU/CN=uozu_client/emailAddress=me@me.com" \
    -keyout uozu.client.key -out uozu.client.csr

# sign server certificate with the intermediate CA:
openssl x509 -req -days 365 -in uozu.client.csr -CA uozusign_intermediate.crt \
    -CAkey uozusign_intermediate.key -CAcreateserial -out uozu.client.crt

# create certificate chain to root (don't include the root)
cat uozu.client.crt uozusign_intermediate.crt > uozu.client.chain.crt
