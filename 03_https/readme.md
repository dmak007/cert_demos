Using a self-signed certificate, we can serve content over https.

Run `run_server.sh`, and browse to https://localhost. You should
see a security warning in your browser. This is because the browser
doesn't trust the self-signed certificate used by this server.

The certificate is in `certificate.crt`. This was created using the
script `gen_cert.sh`.

You can use openssl to view the certificate with the following command

`openssl x509 -in certificate.crt -text -noout`

- `text`:  outputs the certificate in text format
- `noout`: disables output of the encoded certificate

You can also view the private key using openssl:

`openssl rsa -in private_key.key -text -noout`
