# Mutual authentication

If you want an extra layer of security, and a maintenance headache,
the http server can require certificates from connecting clients.

Run `run_server.sh` to start the https server that requires a client
certificate. Browse to https://localhost, and proceed past the security
warning. You'll see an error from nginx saying `No required SSL certificate was sent`.
This is true. nginx has been configured to require a client certificate
to start a secure connection.

Note that openssl s_client seems to connect successfully without a client
certificate:

    echo "Q" | openssl s_client -connect localhost:443 -CAfile certificate.crt

    # messages from openssl:
    # ...
    # Verify return code: 0 (ok)
    # ...
    # DONE

However, as soon as a HTTP request is sent, nginx responds with a bad
request:

    echo $'GET / HTTP/1.0\r\n' | openssl s_client -connect localhost:443 -CAfile certificate.crt

    # Bad request (400) from  nginx:
    # ...
    # No required SSL certificate was sent

You can instruct openssl and curl to send the required client certificate:

    echo $'GET / HTTP/1.0\r\n' | openssl s_client -connect localhost:443 \
    -CAfile certificate.crt -cert certificate.crt -key private_key.key

    curl https://localhost --cacert certificate.crt --cert certificate.crt --key private_key.key

Depending on your environment, you can configure your browser to send a client
certificate. Eg. for Chrome on Windows:

- bundle the certificate and private key into a pfx file:

    `openssl pkcs12 -export -out certificate.pfx -inkey private_key.key -in certificate.crt`

- install the certificate into Windows' trust store:
    - double click on certificate.pfx. This opens the certificate import wizard.
    - select Current User, click next twice
    - enter the file passphrase (entered when you created the pfx file)
    - choose the personal store, click next, then finish

- restart Chrome
- browse to https://localhost, proceed past the security warning
- Chrome will prompt you to select the client certificate to use. There should
  only be one - the certificate you just installed. Select this and click OK.
- The homepage should appear
