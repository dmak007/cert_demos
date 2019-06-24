# Debugging certificates

openssl comes with a handy `verify` command which can be used to check that
certificates are valid when used together.

For this demo, we'll use the following certificates:

uozusign_root.crt:          self-signed CA certificate
uozusign_intermediate.crt:  intermediate CA cert, signed by root
uozu.server.com.crt:        'server' certifiate, signed by intermediate
uozu.client.crt:            'client' certificate, signed by intermediate

## Warm up

    openssl verify certs/uozusign_root.crt
    
    # verification fails with 'self signed certificate', but it's actually because the issuer is not trusted

    openssl verify -CAfile certs/uozusign_root.crt certs/uozusign_root.crt

    # verification OK: 'CAfile' tells openssl to trust the given CA, which is the same cert we're verifying

## Scenarios

**server doesn't send chain**

Simulated with openssl verify:

    openssl verify -CAfile certs/uozusign_root.crt certs/uozu.server.com.crt

This fails with 'unable to get local issuer certificate'. In other words, openssl doesn't
know about the intermediate CA that signed the server cert.

    openssl verify -CAfile certs/uozusign_root.crt certs/uozu.server.com.crt

**Client doesn't trust server issuer certificate**
**server cert CN wrong**
**intermediate not marked as CA**
**try -partial_chain (openssl)**

# Client certs

## Scenarios

- client sends wrong cert
- client not send chain


# todo
- write 'certificate setup' at top, showing which certs will be used
