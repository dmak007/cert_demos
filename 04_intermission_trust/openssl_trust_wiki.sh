#!/bin/bash

# Use the frapsoft/openssl docker image, that comes with no trusted CAs.
# Pass it one of GlobalSign's root certificates as a trusted CA to successfully
# verify wikipedia's server certificate. The GlobalSign root certificate was
# downloaded from https://support.globalsign.com/customer/portal/articles/1426602-globalsign-root-certificates

docker run \
    -v $PWD/globalsignr3.crt:/tmp/globalsignr3.crt \
    frapsoft/openssl s_client -CAfile /tmp/globalsignr3.crt -connect en.wikipedia.org:443 < /dev/null