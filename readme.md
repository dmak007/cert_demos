# Certificate demos using docker, nginx, openssl, curl

Figuring out how certificates work, with practical examples. The days
I spent on this saved me a few hours of reading :)

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

- tldr version of all this for ppl like me
- proof-read all docs, test all scripts, rename stuff if needed (eg. 'certificate.crt')
- add pictures
