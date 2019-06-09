# Trusting certificates

## Why is my self-signed certificate on localhost not trusted?

When running nginx with a self-signed cert, browsers show a security warning.
Something to the effect of 'certificate issuer is not trusted'.

This is because we created the certificate, and the browser doesn't trust us.

It turns out that no-one trusts us. Assuming you're running the server from
03_https, run

`curl https://localhost -o /dev/null`

You should see

`curl: (60) SSL certificate problem: self signed certificate`

Similarly to web browsers, curl verifies the server certificate before 
establishing a secure connection. Certificate verification can be disabled 
with the `-k` option:

`curl -k https://localhost -o /dev/null`

Obviously this isn't a secure thing to use in practice, but it's convenient
for testing.

## Why are some websites trusted?

Now run

`curl https://en.wikipedia.org/wiki/Main_Page -o /dev/null`

This works fine - no SSL problem. Why does curl trust wikipedia's
certificate and not our self-signed one? Run

`echo "Q" | openssl s_client -connect en.wikipedia.org:443`

At the top of the output, you'll see a longer version of:

- CN = GlobalSign, verify return:1
- CN = GlobalSign Organization Validation CA - SHA256 - G2, verify return:1
- CN = *.wikipedia.org, verify return:1

I think this is openssl verifying each certificate in the "chain" of 
certificates presented by wikipedia. A bit further down in the output,
we see `Verification: OK`. This means openssl trusts this connection.
Why?

It turns out that openssl can be configured with pre-trusted certificates.
Run

`openssl version -d`

You should see something like 

`OPENSSLDIR: "/mingw64/ssl"`

This is where openssl's configuration is. If you have a look in
/mingw/ssl/certs, you'll see ca-bundle.crt and ca-bundle.trust.crt. You
can google the difference between these files, but essentially they're
all the CAs openssl trusts.

To print out all the certificate subjects in a bundle, run

`awk -v cmd='openssl x509 -noout -subject' '/BEGIN/{close(cmd)};{print | cmd}' < /mingw64/ssl/certs/ca-bundle.crt`

In the output of the above, there is a subject

`OU = GlobalSign Root CA - R3, O = GlobalSign, CN = GlobalSign`

This is also seen in the certificates received from Wikipedia -
the issuer subject of the last certificate in the chain matches
the above subject. This means that the CA that issued Wikipedia's
intermediate certificate is in our list of trusted CAs, so we
can trust the intermediate certificate, thus we can trust the
server certificate.

If this were not the case, we'd see the same SSL errors when
connecting to wikipedia. We can do this with docker images that
don't come with any trusted CAs:

`docker run -it frapsoft/openssl s_client -connect en.wikipedia.org:443`

You can pass trusted CAs to openssl with the `CAfile` option. See
`openssl_trust_wiki.sh` for how to pass the globalsign root certificate
to openssl so that it trusts Wikipedia.

## Can we pretend that our self-signed cert was issued by GlobalSign?

From the above, it seems that one way to make our self-signed certificate
trusted is to make it look as if it was signed by the GlobalSign root CA.
Is this possible?

## todo: trust our self-signed cert