# Certificate file types

These are pretty easily google-able. The gist seems to be that a certificate file:

- may be in base64 or binary encoding
- may contain one or more certificates
- may contain private keys
- may be password protected

The file extension gives you a hint about the file format, but that's all. Look at the contents. From my experience:

`.pem, .cer, .crt, .der, .p7b, .p7c` are all base64 encoded, may contain one or more certificates, looking something like:

    -----BEGIN CERTIFICATE-----
    base64 stuff
    -----END CERTIFICATE-----
    -----BEGIN CERTIFICATE-----
    base64 stuff
    -----END CERTIFICATE-----

`.pfx, .p12` are binary encoded, and may contain certificates and private keys.

## Generating, viewing and converting files

Previous examples have generated certificates and keys using openssl:

    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -subj "/C=AU/CN=asdf/emailAddress=me@me.com" \
            -keyout private_key.key -out certificate.crt

This generates a base64 encoded x509 certificate with a `crt` extension. The
extension doesn't really matter. It also generates a private key file with a
`key` extension, which is again not important.

openssl can be used to view certificate and key files:

    openssl x509 -noout -text -in certificate.crt
    openssl rsa -noout -text -in private_key.key

Sometimes certificates and private keys may be distributed via password-protected
pfx / p12 files. To create one:

    openssl pkcs12 -export -out certificate.p12 -inkey private_key.key -in certificate.crt -passout pass:1234

To view the contents of a p12 file:

    openssl pkcs12 -in certificate.p12 -passin pass:1234

This will prompt for a password, and output the contents in a mix of text and
base64. To view the certificates within the file, copy+paste the base64 certificate
text to a file and output using the x509 command used earlier.

Handy tip: The password for a pfx file may not be the same as the password
           used to encrypt the private key within! If the expected pfx password
           isn't working, try just hitting enter (password = empty string).
