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

    # use -untrusted to specify intermediate CAs
    openssl verify -x509_strict -show_chain -CAfile certs/uozusign_root.crt \
        -untrusted certs/uozusign_intermediate.crt certs/uozu.server.crt

    # alternatively, create a CA chain
    cat certs/uozusign_intermediate.crt certs/uozusign_root.crt > temp.crt
    openssl verify -x509_strict -show_chain -CAfile temp.crt certs/uozu.server.crt
    rm temp.crt

    # note that putting the chain in the certificate file to be verified fails. I couldn't figure out why:
    openssl verify -x509_strict -show_chain -CAfile certs/uozusign_root.crt certs/uozu.server.chain.crt

    echo "Q" | openssl s_client -CAfile certs/uozusign_root.crt localhost:82

    curl --cacert certs/uozusign_root.crt https://localhost:82

Note that some tools/software/libraries can retrieve intermediate certificates if they can't be
found locally, based on URLs provided within certificates in the given chain.

Another note: Technically, if you trust an intermediate CA, then according to X509, you can trust
the target certificate. By default, this isn't how openssl behaves. Some other tools might.
To make `openssl verify` behave this way, you can use the `-partial_chain` option:

    openssl verify -x509_strict -show_chain -partial_chain \
        -CAfile certs/uozusign_intermediate.crt certs/uozu.server.chain.crt

**chain in wrong order**

For nginx to even start, the server certificate chain must be in the 'correct' order. For nginx,
this is

    server cert -> intermediate 1 -> intermediate2 ...

openssl will successfully verify `uozu.server.crt` with a `CAfile` in either order:

    cat certs/uozusign_intermediate.crt certs/uozusign_root.crt > temp.crt
    cat certs/uozusign_root.crt certs/uozusign_intermediate.crt > temp.reverse.crt
    openssl verify -x509_strict -show_chain -CAfile temp.crt certs/uozu.server.crt          # OK
    openssl verify -x509_strict -show_chain -CAfile temp.reverse.crt certs/uozu.server.crt  # OK

**Client doesn't trust server issuer certificate**
**server cert CN wrong**
**intermediate not marked as CA**
**same as above, but use iis**

# Client certs

## Scenarios

- client sends wrong cert
- client not send chain


# todo
- write 'certificate setup' at top, showing which certs will be used
