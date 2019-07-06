# Certificate questions

Here's a list of questions I had at the start of this, and my
answers based on the practical investigation I've done:

## chains

See https://github.com/uozuAho/cert_demos/tree/master/06_cert_chain

- How does the certificate chain work?
    - cert A signs cert B, cert B signs cert C etc. etc. until cert X signs the 'target' cert
    - the 'target' cert is a 'server' or 'client' cert
    - in theory, if you trust any cert A-X, then you trust the target cert
    - in practice, you may have to trust cert A to trust the target cert
- Why do some certificates have a chain and others do not?
    - a chain is optional (although common), depends on your requirements
    - may be self-signed, thus have no chain
    - may be signed by a trusted CA
    - may contain information on where to obtain signing/intermediate certificates
- What are the implications of not having a chain?
    - a self-signed cert must be trusted by the client/server
    - a certificate cannot be trusted if the chain to a trusted CA cannot be established
    - a chain to a trusted CA may be able to be discovered by tracing issuers,
      even if the target certificate doesn't include a chain
- What about if the chain has an intermediate certificate but not a root certificate?
    - it's common to not include the 'root' (self-signed) certificate, as this *must*
      be trusted apriori (not through digital signatures) by the receiving end
- What is the difference between a root certificate and an intermediate certificate?
    - a root cert is self-signed
    - an intermediate cert is signed by another cert

## mutual auth

See https://github.com/uozuAho/cert_demos/tree/master/07_mutual_auth

- How does the server authenticate using a provided client certificate?
    - The server must find a trusted CA in the client cert chain (or trust the client cert directly)
    - This happens in the TLS handshake
- Which certificates need to be on the server (i.e. the client/intermediate/root) in order to authenticate?
    - In short, enough that cerificatescan be traced back to a trusted CAs
    - The server should send its server certificate and chain of all intermediate CAs
        - ie. The server should be loaded with the server certificate and private key,
          and all intermediate CA certificates
    - For client authentication, the server should be loaded with trusted CA certificates that
      client certificates can be signed by.
    - Depending on the tools used, intermediate certificates can be retrieved from URLs
      given in server certificates, negating the need to send intermediates. If unsure, it's
      best to send all intermediates.
- Is this answer different depending on whether there is a certificate chain?
    - No
- How to identify whether a certificate is a client or server certificate?
    - Note that there's nothing fundamentally different about a 'client' and 'server' cert
    - Server certs will usually have a CN corresponding to the domain of the server
    - Certs may contain an extension 'key usage', which specifies what the certificate
      is to be used for (enforcement probably depends on the software used)
- Is it called a mutual certificate, a client certificate or something else?
    - a certificate used to authenticate a client to a server is typically called a 'client
      certificate'
    - I've seen various names for what we're interested in: mutual authentication, two-way
      authentication, mutual ssl, mutual tls
- Are 'mutual certificates' a thing, or is it 'mutual authentication',
  and each party needs to receive a certificate they trust from the other party?
    - Mutual auth (as per above)
    - No mutual certs, just server and client certs (well, just certs, really)
- Can you get 'mutual certs' that are issued together and must be used together?
    - Nope. As long as you trust the cert itself, or a CA in the chain, any cert
      can be used.
- Does it matter which 'certificate store' you add a cert to? Does this differ by operating system?
    - Note: only did a bit of research on this
    - Yes, it matters, eg.
        - Putting a cert in Windows' 'Trusted Root Certification Authorities' will mean Windows
          will trust any cert signed by this cert. Putting the same cert in 'Personal' doesn't have
          the same effect. Not sure what the personal store is for ... client certs?
    - Yes, depends on implementation, OS etc.
        - eg clients/servers on linux seem to trust anything in `/etc/ssl/cert.pem` on `/etc/ssl/certs/*`

## Cert files

See https://github.com/uozuAho/cert_demos/tree/master/08_file_types

- Why are there so many cert file formats? does it matter which one you use?
    - Dunno why. Just use whatever your software supports.
    - Many files, just a few aspects:
        - base64 or binary encoding
        - may contain one or more certs
        - may contain one or more keys
- How do we dump cert info using `openssl`? How does this differ according to file formats?
    - openssl has various commands to handle different file types
    - for DER/PEM (eg. .crt, .cer, .der), use `openssl x509 -noout -text -in FILE`
    - for p12/pfx, use `openssl pkcs12 -in FILE -passin pass:PASSWORD`
        - this will get you some of the way, you'll probably need `openssl x509` after this
    - man pages and google are your friend

## Debugging

See https://github.com/uozuAho/cert_demos/tree/master/09_debugging

- If your cert config is incorrect, how do you debug it?
    - Use a variety of tools. Each one has its quirks, so it's best to get a number of opinions!
    - Try
        - `openssl verify`
        - `openssl s_client` can give useful information about the SSL/TLS handshake
        - `curl`
        - Web browsers
        - Logs from your web server
