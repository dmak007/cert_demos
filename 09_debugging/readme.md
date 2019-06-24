# Debugging certificates

openssl comes with a handy `verify` command which can be used to check that
certificates are valid when used together.

For this demo, we'll use the following certificates:

uozusign_root.crt:          self-signed CA certificate
uozusign_intermediate.crt:  intermediate CA cert, signed by root
uozu.server.crt:            server certifiate, signed by intermediate
uozu.client.crt:            client certificate, signed by intermediate

## Getting started

Run `./run_servers.sh` to run all the http servers used in this demo

Warm up with these commands:

    openssl verify certs/uozusign_root.crt
    
    # verification fails with 'self signed certificate', but it's actually because the issuer is not trusted

    openssl verify -CAfile certs/uozusign_root.crt certs/uozusign_root.crt

    # verification OK: 'CAfile' tells openssl to trust the given CA, which is the same cert we're verifying

## Scenarios

**server doesn't send chain**

    # simulate with openssl verify
    openssl verify -CAfile certs/uozusign_root.crt certs/uozu.server.crt

    # use openssl s_client
    echo "Q" | openssl s_client -CAfile certs/uozusign_root.crt localhost:81

The above fail with 'unable to get local issuer certificate'. In other words, openssl doesn't
know about the intermediate CA that signed the server cert. The server needs to send the
certificate chain back to the root certificate, for the client to be able to verify the
server certficate:

    openssl verify -CAfile certs/uozusign_root.crt certs/uozu.server.chain.crt
    echo "Q" | openssl s_client -CAfile certs/uozusign_root.crt localhost:82

    # TODO: make server cert CN=localhost
    curl --cacert certs/uozusign_root.crt https://localhost:82

TODO: why do nginx/openssl use different cert chain order??? is one wrong? which is the 'right' way?
TODO: confirm: cert info can give website to retrieve intermediate certs, so sending chain may be
      optional

**try -partial_chain (openssl)**
**chain in wrong order**
**Client doesn't trust server issuer certificate**
**server cert CN wrong**
**intermediate not marked as CA**

# Client certs

## Scenarios

- client sends wrong cert
- client not send chain


# todo
- write 'certificate setup' at top, showing which certs will be used
