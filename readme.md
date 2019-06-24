# Certificate demos using nginx and docker

# Required knowledge

It will probably help to know some docker basics. Hopefully this
should suffice for the rest:

- nginx:   a HTTP server / reverse-proxy
- openssl: a cryptography tool that can create certificates,
           and do many other things related to certificates and keys
- curl:    a terminal-based HTTP client

# Before you start

Install docker.

If running in msys/windows, run `source 00_init_env.sh`.
This project was developed on Windows, so that'll show in
the path names etc. Just be aware you may need to tweak
things a bit to run in other OSs.

# Run the demos

Proceed through each numbered folder to see different server/auth
etc. configurations. Each folder has a readme with details about
what's happening.

# todo

- debugging
    - with openssl
        - play with verify
    - via nginx logs
    - scenarios
        - chain incomplete (server and client)
        - untrusted cert
- proof-read all docs, test all scripts
- write an openssl command cheat sheet
- write a list of questions answered by doing all this
    - How does the certificate chain work?
    - Why do some certificates have a chain and others do not?
    - What are the implications of not having a chain?
    - What about if the chain has an intermediate certificate but not a root certificate?
    - What is the difference between a root certificate and an intermediate certificate?
    - How does the server authenticate using a provided client certificate?
    - Which certificates need to be on the server (i.e. the client/intermediate/root) in order to authenticate?
    - Is this answer different depending on whether there is a certificate chain?
    - How to identify whether a certificate is a client or server certificate?
    - Is it called a mutual certificate, a client certificate or something else?
    - Are 'mutual certificates' a thing, or is it 'mutual authentication',
      and each party needs to receive a certificate they trust from the other party?
    - Can you get 'mutual certs' that are issued together and must be used together?
    - Does it matter which 'certificate store' you add a cert to? Does this differ by operating system?
    - Why are there so many cert file formats? does it matter which one you use?
    - How do we dump cert info using `openssl`? How does this differ according to file formats?
    - If your cert config is incorrect, how do you debug it?
- tldr version for ppl like me