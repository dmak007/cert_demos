# Debugging certificates

There are a number of ways to verify that your certificate setup is correct.
There's no silver bullet for this, and it often takes several tools to confirm
problems.

Some of the tools we'll be using are:

- `openssl s_client`
- `curl`
- `openssl verify`
    - gives misleading results, use with caution

You can also use various web browsers to inspect certificates and potential issues.

Here are some of the certificates we'll be using in this demo:

certs/uozusign_root.crt:          self-signed CA certificate
certs/uozusign_intermediate.crt:  intermediate CA cert, signed by root
certs/uozu.server.localhost.crt:  server certifiate, signed by intermediate
certs/uozu.client.crt:            client certificate, signed by intermediate

## Getting started

Run `./run_servers.sh` to run all the http servers used in this demo

## Scenarios

Below are some certificate configuration problems that you may come across,
and some ways of identifying them.

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

**server cert CN wrong**

A common security check that https clients (including browsers) perform is checking that
the CN matches the domain of the website presenting the certificate. The following curl
request works, since the server on port 82 uses a certificate with a CN = localhost:

    curl --cacert certs/uozusign_root.crt https://localhost:82

The server running on port 83 uses CN = uozu.server.com, which curl complains about:

    curl --cacert certs/uozusign_root.crt https://localhost:83

    > curl: (60) SSL: certificate subject name 'uozu.server.com' does not match target host name 'localhost'

`openssl s_client` doesn't seem to care about this, perhaps as it just verifies the certificates
themselves:

    echo "Q" | openssl s_client -CAfile certs/uozusign_root.crt localhost:83

    > OK

**intermediate not marked as CA**

I'm not sure how likely this is to happen in practice, but it happened to me while
creating this project. The x509 spec states that only a CA certificate can sign other
certificates. `openssl` lets you sign certificates with non-CA certificates, leading
to issues such as the following:

    # verify intermediate cert not marked as a CA cert
    openssl verify -CAfile certs/uozusign_root.crt certs/uozusign_intermediate.notca.crt

    > OK  # this is fine, the intermediate cert is valid, it just shouldn't be used
          # to sign other certificates

    # verify server cert signed by the non-CA intermediate
    openssl verify -CAfile certs/uozusign_root.crt -untrusted \
        certs/uozusign_intermediate.notca.crt certs/uozu.server.localhost.notca.crt

    > error 24 at 1 depth lookup: invalid CA certificate  # OK, this is what we expected

    curl --cacert certs/uozusign_root.crt https://localhost:84

    > SSL certificate problem: invalid CA certificate  # good

    echo "Q" | openssl s_client -CAfile certs/uozusign_root.crt localhost:84

    > Verify return code: 24 (invalid CA certificate)  # good

# Client certs

## Scenarios

- client sends wrong cert
- client not send chain


# todo
- iis ... meh?
