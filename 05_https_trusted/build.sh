#!/bin/bash

docker build -f dockerfile-no-trust -t uozuaho/sslcurl_no_trust .
docker build -f dockerfile-trust-us -t uozuaho/sslcurl_trust_us .
