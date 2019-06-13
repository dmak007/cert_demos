# Trusting our HTTPS server

As we saw in 04, we can instruct openssl to trust the certificate
used by our HTTPS server from 03:

    echo "Q" | openssl s_client -CAfile certificate.crt -connect localhost:443

However, rather then needing to pass our certificate to every client
that needs to talk to our HTTPS server, we can install our certificate
into a 'trusted certificate store' (?)

## Setup

Before we trust our certificate, let's create an isolated environment on which
we can build. Our environment will contain

- nginx server listening on 443 with our self-signed certificate
- A client docker image containing curl, openssl and no trusted certiciates.
  This client will be used to communicate with the server.

`run_server.sh` fires up our trusty server, using the certificate generated
by `gen_cert.sh`. It also creates a network called `05_net` over which we
can use to communicate with the server from other containers.

Once the server is running, run `docker build -t uozuaho/sslcurl .` to 
build the client docker image.

**todo** this next part is overly complicated, it'd be nice to find an
easier way to communicate between containers.

Now run `docker network inspect 05_net`. You should see a container in the
network. Copy its IPv4Address. Now run
`docker run -it --network 05_net uozuaho/sslcurl curl <container IP>`

You should see the welcome page from the nginx server. Now run
`docker run -it --network 05_net uozuaho/sslcurl curl https://<container IP>`

You should see an error about certificate locations. This is because the
uozuaho/sslcurl docker image doesn't come with any trusted ssl certificates.

You should see the 'self signed certiciate' error from openssl:

```
docker run -it --network 05_net uozuaho/sslcurl \
    sh -c "echo 'Q' | openssl s_client -connect 172.21.0.2:443"
```

## Add certificate to client's trusted certificates

