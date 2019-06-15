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

- if an intermediate cert is trusted and the root isn't, can we trust the server cert?
- pki/pkcs12 files
- certificate chain
- mutual auth
- debugging
    - with openssl
    - via nginx logs
- proof-read all docs, test all scripts