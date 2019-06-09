# Certificate demos using nginx and docker

# Before you start

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
- use certs with passwords
    04
- pki/pkcs12 files
- certificate chain
- mutual auth