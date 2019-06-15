# Certificate chain

Root:           UozuSign root
Intermediate:   UozuSign intermediate
Server:         uozuaho.com.crt

The root signs the intermediate certificate, and the intermediate signs the server certificate.

# Setup 1: server sends server cert

client trusts root - doesn't work:

`echo "Q" | openssl s_client -CAfile certs/uozusign_root.crt localhost:443`

Client doesn't trust server, since it doesn't know about the intermediate cert.

client trusts intermediate - doesn't work. **todo** why not?

`echo "Q" | openssl s_client -CAfile certs/uozusign_intermediate.crt localhost:443`

client trusts server cert - doesn't work. **todo** why not?

`echo "Q" | openssl s_client -CAfile certs/uozuaho.com.crt localhost:443`

# Setup 2: server sends certificate chain to root

- client trusts root, works
- client trusts intermediate, doesn't work
- client trusts server cert, doesn't work

# todo
- why doesn't trusting the immediate/server cert work when the server
  presents the server cert (with or without chain)?
- clean this up once you know what's going on