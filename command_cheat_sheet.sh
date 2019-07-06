# ------------------------------------------------------------------
# openssl

# read

# get openssl version
openssl version
# see where openssl's trusted certs are
openssl version -d
# output details of a certificate
openssl x509 -in certificate.crt -text -noout
# output the fingerprint/thumbprint of a certificate
openssl x509 -in certificate.crt -noout -fingerprint
# output details of a pfx / p12 file
openssl pkcs12 -in certificate.p12

# write

# create a certificate signing request
openssl req -newkey rsa:2048 -subj "/C=AU/CN=this.com" -keyout private.key -out cert.csr
# create a CA certificate signing request
openssl req -addext basicConstraints=CA:TRUE -newkey rsa:2048 -subj "/C=AU/CN=this.com" -keyout private.key -out cert.csr
# create a self-signed certificate
openssl req -x509 -newkey rsa:2048 -subj "/C=AU/CN=this.com" -keyout private.key -out cert.crt
# create a self-signed certificate with unencrypted private key (nodes = no DES = no encryption)
openssl req -x509 -nodes -newkey rsa:2048 -subj "/C=AU/CN=this.com" -keyout private.key -out cert.crt
# sign a certificate
openssl x509 -req -in certificate.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out certificate.crt
# encrypt a private key
openssl rsa -aes256 -in private_key.key -out private_key_encrypted.key
# write a certificate and private key to a p12 file
openssl pkcs12 -export -out cert.p12 -inkey cert.key -in cert.crt

# connect

# connect to localhost. echo Q needed since s_client awaits commands. Q = quit
echo "Q" | openssl s_client -connect localhost:443
# connect to localhost, trusting the given certificate authorities (multiple certs can be in ca.crt)
echo "Q" | openssl s_client -CAfile ca.crt -connect localhost:443
# connect to localhost, sending a client certificate
echo "Q" | openssl s_client -cert client.crt -key client.key -connect localhost:443 

# verify

# verify a certificate
openssl verify cert.crt
# verify a certificate with the given trusted root CAs
openssl verify -CAfile ca.crt cert.crt
# verify a certificate with the given trusted root CAs, and 'untrusted' intermediate certificates
openssl verify -CAfile ca.crt -untrusted intermediates.crt cert.crt
# verify a certificate, adhering strictly to x509 spec (no workarounds), printing chain details
openssl verify -x509_strict -show_chain cert.crt
# verify a certificate, stopping chain verification as soon as a trusted CA is found
openssl verify -partial_chain -CAfile ca.crt cert.crt


# ------------------------------------------------------------------
# curl

# GET from the given URL and print the response
curl http://localhost
# GET from the given URL, just print any errors
curl http://localhost -o /dev/null
# GET from URL, ignore any certificate problems
curl -k https://localhost
# GET from URL, trusting the given CA certs
curl --cacert cert.crt https://localhost
# GET from URL, sending a client certificate
curl https://localhost --cert client.crt --key client.key