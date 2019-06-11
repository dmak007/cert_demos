## Can we forge GlobalSign's signature on our certificate?

Let's try. `run_server.sh` runs an nginx server, using certificate.crt, which
has been signed by a fake GlobalSign certificate, which is `fake_globalsign.crt` in this
directory.

With the above server running, try `curl https://localhost -o /dev/null`.
This time, instead of seeing the 'self signed certificate' error we saw before,
we see `curl: (35) error:0407008A:rsa routines:RSA_padding_check_PKCS1_type_1:invalid padding`.
Weird. Let's try openssl:

`echo "Q" | openssl s_client -connect localhost:443`

In the output of the above, you will see `Verification error: certificate signature failure`.
This means that the fake 'GlobalSign' signature on the certificate.crt is bad, ie. doesn't
match the signature of the GlobalSign CA that openssl trusts.

To get a valid GlobalSign signature on our certificate, we need to know the private
key that goes along with GlobalSign's public root certificate. Funnily enough, this is
kept secret, so we can't go around pretending to be GlobalSign. This is why you should
guard your private keys! The only way to get your certificate signed by GlobalSign is
to ask them nicely and pay them money: https://www.globalsign.com/en-au/lp/switch-your-ssl-service-provider/#Contact

Alternatively, if you can convince someone to trust our fake globalsign CA, then browsers,
OSs etc. will happily trust our certificate!:

`echo "Q" | openssl s_client -CAfile fake_globalsign.crt -connect localhost:443`
