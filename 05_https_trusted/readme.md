# Trusting our HTTPS server

As we saw in 04, we can instruct openssl to trust the certificate
used by our HTTPS server from 03:

    echo "Q" | openssl s_client -CAfile certificate.crt -connect localhost:443

However, rather then needing to pass our certificate to every client
that needs to talk to our HTTPS server, we can install our certificate
into the system's trusted CA store.

## Setup

Before we trust our certificate, let's create an isolated environment on which
we can build. Our environment will contain

- nginx server listening on 443 with our self-signed certificate
- A client docker image containing curl, openssl and no trusted certiciates.
  This client will be used to communicate with the server.

`run_server.sh` fires up our trusty server, using the certificate generated
by `gen_cert.sh`. It also creates a network called `05_net` over which we
can use to communicate with the server from other containers.

Once the server is running, run
`docker build -f dockerfile-no-trust -t uozuaho/sslcurl_no_trust .` to build the
client docker image.

**todo** this next part is overly complicated, it'd be nice to find an
easier way to communicate between containers.

Now run `docker network inspect 05_net`. You should see a container in the
network. Copy its IPv4Address. Now run
`docker run -it --network 05_net uozuaho/sslcurl_no_trust curl <container IP>`

You should see the welcome page from the nginx server. Now run
`docker run -it --network 05_net uozuaho/sslcurl_no_trust curl https://<container IP>`

You should see an error about certificate locations. This is because the
uozuaho/sslcurl_no_trust docker image doesn't come with any trusted ssl certificates.

You should see the 'self signed certiciate' error from openssl:

```
docker run --network 05_net uozuaho/sslcurl_no_trust \
    sh -c "echo 'Q' | openssl s_client -connect <container ip>:443"
```

If you try Wikipedia, you'll get an error saying 'unable to get local
issuer certificate', meaning the issuer of Wikipedia's certificate is
not known by our client docker image:

```
docker run --network 05_net uozuaho/sslcurl_no_trust \
    sh -c "echo 'Q' | openssl s_client -connect en.wikipedia.org:443"
```

## Add certificate to client's trusted certificates

Now build a docker image with our self-signed certificate installed, by running:

`docker build -f dockerfile-trust-us -t uozuaho/sslcurl_trust_us .`

openssl should now be able to successfully connect to our server:

```
docker run --network 05_net uozuaho/sslcurl_trust_us \
    sh -c "echo 'Q' | openssl s_client -connect <container ip>:443"
```

curl will fail with `certificate subject name 'my_common_name' does not match target host name '172.23.0.2'`.
This is because the common name (CN) in our certificate doesn't match
the host section of our server's url. Fixing this is beyond the scope
of my interest.
